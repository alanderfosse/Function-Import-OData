class ZCL_ZDEFUNCTION_DPC_EXT definition
  public
  inheriting from ZCL_ZDEFUNCTION_DPC
  create public .

public section.

  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~EXECUTE_ACTION
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS ZCL_ZDEFUNCTION_DPC_EXT IMPLEMENTATION.


  METHOD /iwbep/if_mgw_appl_srv_runtime~execute_action.
    DATA: ls_para         LIKE LINE OF it_parameter,
          lt_emp          TYPE zcl_zdefunction_mpc=>tt_emp,
          ls_readpara     TYPE ztb_emp,
          ls_insertstatus TYPE zcl_zdefunction_mpc=>ts_insertstatus.

    CASE iv_action_name.
      WHEN 'FIDesignation'.
        READ TABLE it_parameter INTO ls_para WITH KEY name = 'IPDesignation'.
        IF sy-subrc EQ 0.
"/sap/opu/odata/sap/ZDEFUNCTION_SRV/FIDesignation?IPDesignation='CLEANER'
"SE11 table
"EMPID - EMPNAME - EMPDESC
"003   - JHON    - CLEANER

          SELECT *
            FROM ztb_emp
              INTO TABLE lt_emp
                WHERE empdesc = ls_para-value.

          IF sy-subrc EQ 0.
            copy_data_to_ref(
              EXPORTING
                is_data = lt_emp
              CHANGING
                cr_data = er_data
            ).
          ENDIF.
        ENDIF.
      WHEN 'FIInsert'.
        CLEAR ls_para.
"/sap/opu/odata/sap/ZDEFUNCTION_SRV/FIInsert?Emp_id='007'&Emp_name='Test'&Emp_desc='Director'
        READ TABLE it_parameter INTO ls_para WITH KEY name = 'Emp_id'.
        IF sy-subrc EQ 0.
          ls_readpara-empid = ls_para-value.
        ENDIF.
        CLEAR ls_para.

        READ TABLE it_parameter INTO ls_para WITH KEY name = 'Emp_name'.
        IF sy-subrc EQ 0.
          ls_readpara-empname = ls_para-value.
        ENDIF.
        CLEAR ls_para.

        READ TABLE it_parameter INTO ls_para WITH KEY name = 'Emp_desc'.
        IF sy-subrc EQ 0.
          ls_readpara-empdesc = ls_para-value.
        ENDIF.
        CLEAR ls_para.

        INSERT ztb_emp FROM ls_readpara.
        IF sy-subrc EQ 0.
          ls_insertstatus-status = 'S'.
          ls_insertstatus-message = 'Inserted succesfully'.
        ELSE.
          ls_insertstatus-status = 'E'.
          ls_insertstatus-message = 'Insert operation is failed'.
        ENDIF.

        copy_data_to_ref(
          EXPORTING
            is_data = ls_insertstatus
          CHANGING
            cr_data = er_data
        ).
      WHEN OTHERS.
*    Do Nothing
    ENDCASE.
  ENDMETHOD.
ENDCLASS.
