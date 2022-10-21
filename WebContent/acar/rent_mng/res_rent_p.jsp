<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.res_search.*, acar.util.*, acar.car_service.*, acar.serv_off.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>�ڵ����뿩�̿��༭</title>
<link rel="stylesheet" type="text/css" href="../../include/print.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	function onprint(){
		factory.printing.header 	= ""; //��������� �μ�
		factory.printing.footer 	= ""; //�������ϴ� �μ�
		factory.printing.portrait 	= true; //true-�����μ�, false-�����μ�    
		factory.printing.leftMargin 	= 8.0; //��������   
		factory.printing.rightMargin 	= 8.0; //��������
		factory.printing.topMargin 	= 8.0; //��ܿ���    
		factory.printing.bottomMargin 	= 8.0; //�ϴܿ���	
		factory.printing.Print(true, window);//arg1-��ȭ����ǥ�ÿ���(true or false), arg2-��ü������orƯ��������
	}
	
	//�ݾ� ����	
	function set_amt(obj){
		obj.value = parseDecimal(obj.value);
		var fm = document.form1;	
		if(obj==fm.fee_s_amt){
			fm.fee_v_amt.value = parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) * 0.1) ;
			fm.fee_amt.value = parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) + toInt(parseDigit(fm.fee_v_amt.value)));
		}else if(obj==fm.fee_v_amt){
			fm.fee_s_amt.value = parseDecimal(toInt(parseDigit(fm.fee_v_amt.value)) / 0.1) ;
			fm.fee_amt.value = parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) + toInt(parseDigit(fm.fee_v_amt.value)));
		}else if(obj==fm.fee_amt){
			fm.fee_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.fee_amt.value))));
			fm.fee_v_amt.value = parseDecimal(toInt(parseDigit(fm.fee_amt.value)) - toInt(parseDigit(fm.fee_s_amt.value)));		
		}else if(obj==fm.dc_s_amt){
			fm.dc_v_amt.value = parseDecimal(toInt(parseDigit(fm.dc_s_amt.value)) * 0.1) ;
			fm.dc_amt.value = parseDecimal(toInt(parseDigit(fm.dc_s_amt.value)) + toInt(parseDigit(fm.dc_v_amt.value)));
		}else if(obj==fm.dc_v_amt){
			fm.dc_s_amt.value = parseDecimal(toInt(parseDigit(fm.dc_v_amt.value)) / 0.1) ;
			fm.dc_amt.value = parseDecimal(toInt(parseDigit(fm.dc_s_amt.value)) + toInt(parseDigit(fm.dc_v_amt.value)));
		}else if(obj==fm.dc_amt){
			fm.dc_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.dc_amt.value))));
			fm.dc_v_amt.value = parseDecimal(toInt(parseDigit(fm.dc_amt.value)) - toInt(parseDigit(fm.dc_s_amt.value)));		
		}else if(obj==fm.etc_s_amt){
			fm.etc_v_amt.value = parseDecimal(toInt(parseDigit(fm.etc_s_amt.value)) * 0.1) ;
			fm.etc_amt.value = parseDecimal(toInt(parseDigit(fm.etc_s_amt.value)) + toInt(parseDigit(fm.etc_v_amt.value)));
		}else if(obj==fm.etc_v_amt){
			fm.etc_s_amt.value = parseDecimal(toInt(parseDigit(fm.etc_v_amt.value)) / 0.1) ;
			fm.etc_amt.value = parseDecimal(toInt(parseDigit(fm.etc_s_amt.value)) + toInt(parseDigit(fm.etc_v_amt.value)));
		}else if(obj==fm.etc_amt){
			fm.etc_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.etc_amt.value))));
			fm.etc_v_amt.value = parseDecimal(toInt(parseDigit(fm.etc_amt.value)) - toInt(parseDigit(fm.etc_s_amt.value)));		
		}
		fm.rent_tot_amt2.value = parseDecimal(toInt(parseDigit(fm.fee_amt.value)) - toInt(parseDigit(fm.dc_amt.value)) + toInt(parseDigit(fm.ins_amt.value)) + toInt(parseDigit(fm.etc_amt.value)) );
		
	}			
	
//-->
</script>
</head>
<body leftmargin="15" onLoad="javascript:onprint()">
<object id="factory" style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,4,438,06"> 
</object> 
<%
	String s_cd = request.getParameter("s_cd")==null?"":request.getParameter("s_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//��������
	Hashtable reserv = rs_db.getCarInfo(c_id);
	//�ܱ�������
	RentContBean rc_bean = rs_db.getRentContCase(s_cd, c_id);
	//������
	RentCustBean rc_bean2 = rs_db.getRentCustCase(rc_bean.getCust_st(), rc_bean.getCust_id());
	//�ܱ������-���뺸����
	RentMgrBean rm_bean1 = rs_db.getRentMgrCase(s_cd, "1");
	RentMgrBean rm_bean2 = rs_db.getRentMgrCase(s_cd, "2");
	RentMgrBean rm_bean3 = rs_db.getRentMgrCase(s_cd, "3");
	//�ܱ�뿩����
	RentFeeBean rf_bean = rs_db.getRentFeeCase(s_cd);
	String rent_st = rc_bean.getRent_st();
	String use_st = rc_bean.getUse_st();
	//�������
	Hashtable accid = rs_db.getInfoAccid(rc_bean.getSub_c_id(), rc_bean.getAccid_id());
	
	if(rf_bean.getEtc_s_amt() == 0 && rf_bean.getCons1_s_amt()+rf_bean.getCons2_s_amt()+rf_bean.getNavi_s_amt() >0){
		rf_bean.setEtc_s_amt(rf_bean.getCons1_s_amt()+rf_bean.getCons2_s_amt()+rf_bean.getNavi_s_amt());
		rf_bean.setEtc_v_amt(rf_bean.getCons1_v_amt()+rf_bean.getCons2_v_amt()+rf_bean.getNavi_v_amt());
	}	
	
%>
<form action="res_rent_u_a.jsp" name="form1" method="post" >
  <table border=0 cellspacing=0 cellpadding=0 width=700>
    <tr> 
      <td height="50" width="220"><img src="/images/logo.gif" aligh="absmiddle" border="0" width="128" height="30">
      </td>
      <td height="50" width="480" colspan="2"><font size="5"><b>�� �� �� �� �� �� �� 
        �� �� ��</b></font></td>
    </tr>
    <tr> 
      <td width="220" align="right">&nbsp;</td>
      <td width="120" align="right">&nbsp;</td>
      <td align="right" width="360">TEL.02-757-0802</td>
    </tr>
    <tr> 
      <td class="line" colspan="3"> 
        <table border="1" cellspacing="0" cellpadding="0" width=700 bordercolor="#000000">
          <tr> 
            <td class=title width='90' align="center">����ȣ</td>
            <td width='150' align="center">&nbsp;<%=rc_bean.getRent_s_cd()%></td>
            <td class=title width='80' align="center">������</td>
            <td width="150" align="center" >&nbsp;<%=c_db.getNameById(rc_bean.getBrch_id(), "BRCH")%></td>
            <td class=title width='80' align="center">�����</td>
            <td width="150" align="center" >&nbsp;<%=c_db.getNameById(rc_bean.getBus_id(), "USER")%></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td colspan="3" height="2" align="right"></td>
    </tr>
    <tr> 
      <td class="line" colspan="3"> 
        <table border="1" cellspacing="0" cellpadding="0" width=700 bordercolor="#000000">
          <tr> 
            <td class=title width='90' align="center">������</td>
            <td width='260' align="center">&nbsp;<%=rc_bean2.getCust_st()%></td>
            <td class=title width='90' align="center">�뿩����</td>
            <td width="260" align="center" >&nbsp; 
              <%if(rc_bean.getRent_st().equals("1")){%>
              �ܱ�뿩 
              <%}else if(rc_bean.getRent_st().equals("2")){%>
              ������� 
              <%}else if(rc_bean.getRent_st().equals("3")){%>
              ������ 
              <%}else if(rc_bean.getRent_st().equals("9")){%>
              ������� 			  
              <%}else if(rc_bean.getRent_st().equals("10")){%>
              �������� 			  
              <%}else if(rc_bean.getRent_st().equals("4")){%>
              �뿩 
              <%}else if(rc_bean.getRent_st().equals("5")){%>
              �������� 
              <%}else if(rc_bean.getRent_st().equals("6")){%>
              �������� 
              <%}else if(rc_bean.getRent_st().equals("7")){%>
              �������� 
              <%}else if(rc_bean.getRent_st().equals("8")){%>
              ������ 
              <%}else if(rc_bean.getRent_st().equals("12")){%>
              ����Ʈ
              <%}%>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td colspan="3" height="5" align="right"></td>
    </tr>
    <tr> 
      <td class="line" colspan="3"> 
        <table border="1" cellspacing="0" cellpadding="0" width=700 bordercolor="#000000" height="25">
          <tr> 
            <td height="25" bgcolor="#CCCCCC" colspan="6">&nbsp;<b><font size="3">��.��.��.��</font></b></td>
          </tr>
          <tr> 
            <td class=title2 width='90'>����</td>
            <td colspan="2" align="center">&nbsp;<%=rc_bean2.getCust_nm()%></td>
            <td class=title2 width='90'>�������</td>
            <td colspan="2" align="center">&nbsp;<%=AddUtil.ChangeEnpH(rc_bean2.getSsn())%></td>
          </tr>
          <tr> 
            <td class=title2 width='90'>��ȣ</td>
            <td colspan="2" align="center">&nbsp;<%=rc_bean2.getFirm_nm()%></td>
            <td class=title2>����ڵ�Ϲ�ȣ</td>
            <td colspan="2" align="center">&nbsp;<%=rc_bean2.getEnp_no()%></td>
          </tr>
          <tr> 
            <td class=title2 width='90'>�ּ�</td>
            <td colspan="5">&nbsp;<%=rc_bean2.getZip()%>&nbsp;&nbsp;<%=rc_bean2.getAddr()%></td>
          </tr>
          <tr> 
            <td class=title2 width='90'>���������ȣ</td>
            <td colspan="2" align="center">&nbsp;<%=rc_bean2.getLic_no()%></td>
            <td class=title2 rowspan="2">����ó</td>
            <td class=title2 width='60'>��ȭ��ȣ</td>
            <td width='200' align="center">&nbsp;<%=rc_bean2.getTel()%></td>
          </tr>
          <tr> 
            <td class=title2 width='90'>��������</td>
            <td colspan="2" align="center">&nbsp;<%=rc_bean2.getLic_st()%></td>
            <td class=title2>�޴���</td>
            <td align="center">&nbsp;<%=rc_bean2.getM_tel()%></td>
          </tr>
          <tr> 
            <td colspan="6" height="5"></td>
          </tr>
          <tr> 
            <td class=title2 rowspan="3"><%if(rent_st.equals("12")){%>�߰�������<%}else{%>�ǿ�����<%}%></td>
            <td class=title2 width="60">����</td>
            <td width="200" align="center">&nbsp;<%=rm_bean1.getMgr_nm()%></td>
            <td class=title2 >�������</td>
            <td colspan="2" align="center">&nbsp;<%=AddUtil.ChangeEnpH(rm_bean1.getSsn())%></td>
          </tr>
          <tr> 
            <td class=title2 rowspan="2">�ּ�</td>
            <td>&nbsp;<%=rm_bean1.getZip()%>&nbsp;&nbsp;<%=rm_bean1.getAddr()%></td>
            <td class=title2 >���������ȣ</td>
            <td colspan="2" align="center">&nbsp;<%=rm_bean1.getLic_no()%></td>
          </tr>
          <tr> 
            <td>&nbsp;</td>
            <td class=title2 >��ȭ��ȣ</td>
            <td colspan="2" align="center">&nbsp;<%=rm_bean1.getTel()%></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td colspan="3" height="5" align="right"></td>
    </tr>
    <tr> 
      <td class="line" colspan="3"> 
        <table border="1" cellspacing="0" cellpadding="0" width=700 bordercolor="#000000" height="25">
          <tr> 
            <td height="25" bgcolor="#CCCCCC" colspan="3">&nbsp;<b><font size="3">��.��.��.��.��.��</font></b></td>
          </tr>
          <tr> 
            <td class=title2 rowspan="2">�̿�Ⱓ</td>
            <td class=title2 width="60" >�Ⱓ</td>
            <td align="center">&nbsp;<%=rc_bean.getRent_hour()%>�ð� (Hours) <%=rc_bean.getRent_days()%>��(Days) 
              <%=rc_bean.getRent_months()%>����(Months)</td>
          </tr>
          <tr> 
            <td class=title2 >��¥</td>
            <td align="center">&nbsp;<%=AddUtil.ChangeDate3(rc_bean.getRent_start_dt())%> 
              ~ &nbsp;<%=AddUtil.ChangeDate3(rc_bean.getRent_end_dt())%> </td>
          </tr>
          <tr> 
            <td class=title2 width='90'>��Ÿ Ư�̻���</td>
            <td colspan="2">&nbsp;<%=rc_bean.getEtc()%></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td class="line" colspan="3"> 
        <table border="1" cellspacing="0" cellpadding="0" width=700 bordercolor="#000000" height="25">
          <tr> 
            <td height="25" bgcolor="#CCCCCC" colspan="6">&nbsp;<b><font size="3">��.��.��.��</font></b></td>
          </tr>
          <tr> 
            <td class=title2 width="90">����</td>
            <td colspan="3" align="center" >&nbsp;<%=reserv.get("CAR_NM")%>&nbsp;<%=reserv.get("CAR_NAME")%></td>
            <td class=title2 width="90" >����</td>
            <td align="center" width="150">&nbsp;<%=reserv.get("CAR_NM")%></td>
          </tr>
          <tr> 
            <td class=title2 >������ȣ</td>
            <td align="center" width="150">&nbsp;<%=reserv.get("CAR_NO")%></td>
            <td class=title2 width="80">��������</td>
            <td width="140" align="center">&nbsp;<%=reserv.get("FUEL_KD")%></td>
            <td class=title2 >��������Ÿ�</td>
            <td align="center">&nbsp;<%=Util.parseDecimal(String.valueOf(reserv.get("TODAY_DIST")))%>km</td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td class="line" colspan="3"> 
        <table border="1" cellspacing="0" cellpadding="0" width=700 bordercolor="#000000" height="25">
          <tr> 
            <td height="25" bgcolor="#CCCCCC" colspan="6">&nbsp;<b><font size="3">��.��.��.��</font></b></td>
          </tr>
          <tr> 
            <td class=title2 rowspan="4" width="90">�뿩���</td>
            <td align="center" width="60" >&nbsp;</td>
            <td align="center" width="139" >����뿩��</td>
            <td class=title width="137">D/C</td>
            <td class=title width="137">���ú����</td>
            <td class=title width="137">��/����(��Ÿ)��</td>
          </tr>
          <tr> 
            <td class=title2>���ް�</td>
            <td align="center"> �� 
              <input type="text" name="fee_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_s_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
            </td>
            <td class=title > �� 
              <input type="text" name="dc_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getDc_s_amt())%>" size="10" class=titlenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
            </td>
            <td class=title >-</td>
            <td class=title > �� 
              <input type="text" name="etc_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getEtc_s_amt())%>" size="10" class=titlenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
            </td>
          </tr>
          <tr> 
            <td class=title2>�ΰ���</td>
            <td align="center"> �� 
              <input type="text" name="fee_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_v_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
            </td>
            <td class=title > �� 
              <input type="text" name="dc_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getDc_v_amt())%>" size="10" class=titlenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
            </td>
            <td class=title >-</td>
            <td class=title > �� 
              <input type="text" name="etc_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getEtc_v_amt())%>" size="10" class=titlenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
            </td>
          </tr>
          <tr> 
            <td class=title2>�հ�</td>
            <td align="center"> �� 
              <input type="text" name="fee_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_s_amt()+rf_bean.getFee_v_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
            </td>
            <td class=title > �� 
              <input type="text" name="dc_amt" value="<%=AddUtil.parseDecimal(rf_bean.getDc_s_amt()+rf_bean.getDc_v_amt())%>" size="10" class=titlenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
            </td>
            <td class=title > �� 
              <input type="text" name="ins_amt" value="<%=AddUtil.parseDecimal(rf_bean.getIns_s_amt())%>" size="10" class=titlenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
            </td>
            <td class=title > �� 
              <input type="text" name="etc_amt" value="<%=AddUtil.parseDecimal(rf_bean.getEtc_s_amt()+rf_bean.getEtc_v_amt())%>" size="10" class=titlenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
            </td>
          </tr>
          <tr> 
            <td colspan="2" align="center" ><b><font size="3">�Ѱ����ݾ�</font></b></td>
            <td colspan="4">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� 
              <input type="text" name="rent_tot_amt2" value="<%=AddUtil.parseDecimal(rf_bean.getRent_tot_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
            </td>
          </tr>
          <tr> 
            <td class=title2 >�������</td>
            <td colspan="2">&nbsp; 
              <%if(rf_bean.getPaid_way().equals("1")){%>
              ���� 
              <%}%>
              <%if(rf_bean.getPaid_way().equals("2")){%>
              �ĺ� 
              <%}%>
            </td>
            <td class=title2>��������</td>
            <td colspan="2">&nbsp; 
              <%if(rf_bean.getPaid_st().equals("1")){%>
              �ſ�ī�� &nbsp; (ī��No.:<%=rf_bean.getCard_no()%> ) 
              <%}%>
              <%if(rf_bean.getPaid_st().equals("2")){%>
              ���� 
              <%}%>
              <%if(rf_bean.getPaid_st().equals("2")){%>
              �ڵ���ü 
              <%}%>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td colspan="3" height="5" align="right"></td>
    </tr>
    <tr> 
      <td colspan="3" height="5"> 
        <table border="1" cellspacing="0" cellpadding="0" width=700 bordercolor="#000000" height="25">
          <tr> 
            <td height="25" bgcolor="#CCCCCC" colspan="5">&nbsp;<b><font size="3">��.�� 
              / ��.��</font></b></td>
          </tr>
          <tr> 
            <td class=title2 rowspan="2" width="90">��/�����ð�<br>
              �� ���</td>
            <td class=title2 width='60'>����</td>
            <td width="245" align="center">&nbsp;<%=AddUtil.ChangeDate3(rc_bean.getDeli_dt())%></td>
            <td class=title2 width='60'>����</td>
            <td align="center" width="245">&nbsp;<%=AddUtil.ChangeDate3(rc_bean.getRet_plan_dt())%></td>
          </tr>
          <tr> 
            <td class=title2>���</td>
            <td align="center">&nbsp;<%=rc_bean.getDeli_loc()%></td>
            <td class=title2>���</td>
            <td align="center">&nbsp;<%=rc_bean.getRet_loc()%></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td colspan="3" height="5" align="right"></td>
    </tr>
    <tr> 
      <td colspan="3" height="5"> 
        <table border="1" cellspacing="0" cellpadding="0" width=700 bordercolor="#000000" height="25">
          <tr> 
            <td height="25" bgcolor="#CCCCCC" colspan="6">&nbsp;<b><font size="3">��.��.��.��.��.��</font></b></td>
          </tr>
          <tr> 
            <td class=title2 width="90" >��������</td>
            <td align="center" width="150">&nbsp;<%if(accid.get("OFF_NM") != null){%><%=accid.get("OFF_NM")%><%}%></td>
            <td class=title2 width="90">����������ȣ</td>
            <td width="150" align="center">&nbsp;<%if(accid.get("CAR_NO") != null){%><%=accid.get("CAR_NO")%><%}%></td>
            <td class=title2 width="60" >����</td>
            <td align="center" width="160">&nbsp;<%if(accid.get("CAR_NM") != null){%><%=accid.get("CAR_NM")%><%}%></td>
          </tr>
          <tr> 
            <td class=title2 >������ȣ</td>
            <td align="center" width="150">&nbsp;<%if(accid.get("P_NUM") != null){%><%=accid.get("P_NUM")%><%}%></td>
            <td class=title2 >�����ں����</td>
            <td align="center">&nbsp;<%if(accid.get("G_INS") != null){%><%=accid.get("G_INS")%><%}%></td>
            <td class=title2 >�����</td>
            <td align="center">&nbsp;<%if(accid.get("G_INS_NM") != null){%><%=accid.get("G_INS_NM")%><%}%></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td colspan="3" height="5" align="right"></td>
    </tr>
    <tr> 
      <td colspan="2"> 
        <table border="1" cellspacing="0" cellpadding="0" width=335 bordercolor="#000000">
          <tr> 
            <td height="25" bgcolor="#CCCCCC">&nbsp;<b><font size="2">������� �� ��å�ӻ���</font></b></td>
          </tr>
          <tr> 
            <td> 
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td width="82" height="16">* �����ڿ���</td>
                  <td height="16">: �� 26�� �̻�</td>
                </tr>
                <tr> 
                  <td width="82" height="16">* �����ڹ���</td>
                  <td height="16">: �����, ������� ����/����, ����ڰ�</td>
                </tr>
                <tr> 
                  <td width="82" height="16">&nbsp;</td>
                  <td height="16">&nbsp;&nbsp;������ ��</td>
                </tr>
                <tr> 
                  <td width="82" height="16">* ���Գ���</td>
                  <td height="16">: ���ι��(��,��)����,�빰���(3õ�����ѵ�)</td>
                </tr>
                <tr> 
                  <td width="82" height="16">&nbsp;</td>
                  <td height="16">&nbsp;&nbsp;�ڱ��ü�����(���δ� 3õ���� �ѵ�)</td>
                </tr>
                <tr> 
                  <td width="82" height="16">* ��å�ӻ���</td>
                  <td height="16">: ���α���� ���ݿ� ���� ��Ģ��</td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
      </td>
      <td width='360'> 
        <table border="1" cellspacing="0" cellpadding="0" width=360 bordercolor="#000000">
          <tr> 
            <td height="25" bgcolor="#CCCCCC">&nbsp;<b><font size="2">���ú���</font></b></td>
          </tr>
          <tr> 
            <td> 
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td width="65" height="16">* ������</td>
                  <td height="16">: �ڱ��������غ���</td>
                </tr>
                <tr> 
                  <td width="65" height="16">* �������</td>
                  <td height="16">: �������� ���ǿ��ο� ������� �뿩������ �ļպ���</td>
                </tr>
                <tr> 
                  <td width="65" height="16">&nbsp;</td>
                  <td height="16">&nbsp;&nbsp;(��������)</td>
                </tr>
                <tr> 
                  <td colspan="2" height="16">* �����Ⱓ ������ ���������� ����(ǥ�ش뿩���� 70%)</td>
                </tr>
                <tr> 
                  <td height="16">* ��å�� </td>
                  <td height="16">: 30����(������ 50����)</td>
                </tr>
                <tr> 
                  <td height="16"><b>* ��������</b> </td>
                  <td height="16"><b><font size="3">: 
                    <%if(rf_bean.getIns_yn().equals("Y")){%>
                    ���� 
                    <%}else{%>
                    �̰��� 
                    <%}%>
                    &nbsp;</font></b> </td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td height="30">&nbsp;</td>
      <td colspan="2" height="30" align="right">������� : <%=AddUtil.ChangeDate2(rc_bean.getRent_dt())%></td>
    </tr>
    <tr> 
      <td class=line height="10">&nbsp; </td>
      <td class=line height="10">&nbsp;</td>
      <td class=line height="10">&nbsp;</td>
    </tr>
    <tr> 
      <td class=line>�뿩������(�Ӵ���)</td>
      <td class=line colspan="2">�뿩�̿���(������)</td>
    </tr>
    <tr> 
      <td>����� �������� ���ǵ��� 17-3</td>
      <td colspan="2">�� ��� ������ Ȯ���Ͽ� ��� ü���ϰ� ��༭ 1���� ���� ���� ��.</td>
    </tr>
    <tr> 
      <td class=line colspan="3">&nbsp; </td>
    </tr>
    <tr> 
      <td class=line>(��)�Ƹ���ī ��ǥ�̻� ������ (��)</td>
      <td class=line>�� �뿩�̿���</td>
      <td class=line align="right">(��)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
    </tr>
  </table>
</form>
</body>
</html>
