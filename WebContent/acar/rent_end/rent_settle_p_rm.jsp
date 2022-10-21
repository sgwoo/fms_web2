<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.res_search.*, acar.util.*, acar.car_service.*, acar.serv_off.*, acar.user_mng.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="s_bean" class="acar.car_service.ServiceBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>�ڵ����뿩������꼭</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
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
		factory.printing.topMargin 	= 25.0; //��ܿ���    
		factory.printing.bottomMargin 	= 20.0; //�ϴܿ���	
		factory.printing.Print(true, window);//arg1-��ȭ����ǥ�ÿ���(true or false), arg2-��ü������orƯ��������
	}
//-->
</script>
</head>
<body leftmargin="15" onLoad="javascript:onprint()"><!---->
<object id="factory" style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,4,438,06"> 
</object> 
<%
	String s_cd = request.getParameter("s_cd")==null?"":request.getParameter("s_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
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
	//����������
	ScdRentBean sr_bean1 = rs_db.getScdRentCase(s_cd, "1");
	ScdRentBean sr_bean2 = rs_db.getScdRentCase(s_cd, "2");
	ScdRentBean sr_bean6 = rs_db.getScdRentCase(s_cd, "6");
	//�ܱ�뿩��������
	RentSettleBean rs_bean = rs_db.getRentSettleCase(s_cd);
	//�뿪�������
	ScdDrivBean sd_bean1 = rs_db.getScdDrivCase(s_cd, "1");
	ScdDrivBean sd_bean2 = rs_db.getScdDrivCase(s_cd, "2");
	
	//�Ա�ó��
	Vector conts = rs_db.getScdRentList(s_cd);
	int cont_size = conts.size();
	
	//�̼�ä��
	Vector conts2 = rs_db.getScdRentNoList(s_cd);
	int cont_size2 = conts2.size();
	
	//������
	Vector exts = rs_db.getRentContExtList(s_cd);
	int ext_size = exts.size();
	
	int ext_pay_rent_s_amt = 0;
	int ext_pay_rent_v_amt = 0;
	if(cont_size > 0){
		for(int i = 0 ; i < cont_size ; i++){
    			Hashtable sr = (Hashtable)conts.elementAt(i);
    			if(String.valueOf(sr.get("RENT_ST")).equals("5")){
    				ext_pay_rent_s_amt = ext_pay_rent_s_amt + AddUtil.parseInt(String.valueOf(sr.get("RENT_S_AMT")));
    				ext_pay_rent_v_amt = ext_pay_rent_v_amt + AddUtil.parseInt(String.valueOf(sr.get("RENT_V_AMT")));
    			}
    		}
    	}		
		
	int no_pay_rent_amt = 0;	
	if(cont_size2 > 0){
		for(int i = 0 ; i < cont_size2 ; i++){
    			Hashtable sr = (Hashtable)conts2.elementAt(i);
    			if(String.valueOf(sr.get("RENT_ST")).equals("5")){
    				ext_pay_rent_s_amt = ext_pay_rent_s_amt + AddUtil.parseInt(String.valueOf(sr.get("RENT_S_AMT")));
    				ext_pay_rent_v_amt = ext_pay_rent_v_amt + AddUtil.parseInt(String.valueOf(sr.get("RENT_V_AMT")));
    			}    			
			no_pay_rent_amt = no_pay_rent_amt + AddUtil.parseInt(String.valueOf(sr.get("RENT_S_AMT")));
			no_pay_rent_amt = no_pay_rent_amt + AddUtil.parseInt(String.valueOf(sr.get("RENT_V_AMT")));
    		}
    	}
    	
    	//�������
	Hashtable br = c_db.getBranch(rc_bean.getBrch_id());			
	
    	//����ڵ�
    	UsersBean user_bean1 	= umd.getUsersBean(rc_bean.getBus_id());
    	UsersBean user_bean2 	= umd.getUsersBean(rc_bean.getMng_id());
	
%>
<form action="res_rent_u_a.jsp" name="form1" method="post" >
  <table border=0 cellspacing=0 cellpadding=0 width=700>
    <tr> 
      <td height="70" width="220"><img src="/images/logo.gif" aligh="absmiddle" border="0" width="128" height="30"> 
      </td>
      <td height="70" width="480" colspan="2"><font size="5"><b>�� �� �� �� �� �� �� 
        �� �� ��</b></font></td>
    </tr>
    <tr> 
      <td width="220" align="right">&nbsp;</td>
      <td width="120" align="right">&nbsp;</td>
      <td align="right" width="360"></td>
    </tr>
    <tr> 
      <td class="line" colspan="3"> 
        <table border="1" cellspacing="0" cellpadding="0" width=700 bordercolor="#000000">
          <tr> 
            <td class=title width='90' align="center">����ȣ</td>
            <td width='100' align="center">&nbsp;<%=rc_bean.getRent_s_cd()%></td>
            <td class=title width='80' align="center">������</td>
            <td width="100" align="center" >&nbsp;<%=c_db.getNameById(rc_bean.getBrch_id(), "BRCH")%></td>
            <td class=title width='80' align="center">���������</td>
            <td width="250" align="left" >&nbsp;<%=user_bean1.getUser_nm()%> <%=user_bean1.getUser_m_tel()%></td>
          </tr>
          <tr> 
            <td class=title width='90' align="center">������</td>
            <td width='100' align="center">&nbsp;<%=rc_bean2.getCust_st()%></td>
            <td class=title width='80' align="center">�뿩����</td>
            <td width="100" align="center" >&nbsp;����Ʈ</td>
            <td class=title width='80' align="center">���������</td>
            <td width="250" align="left" >&nbsp;<%=user_bean2.getUser_nm()%> <%=user_bean2.getUser_m_tel()%><br>&nbsp;���ó��,����,��࿬��,�ݳ� ���</td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td colspan="3" height="15" align="right"></td>
    </tr>
    <tr> 
      <td class="line" colspan="3"> 
        <table border="1" cellspacing="0" cellpadding="0" width=700 bordercolor="#000000" height="25">
          <tr> 
            <td height="25" bgcolor="#CCCCCC" colspan="4">&nbsp;<b><font size="3">��.��.��.��</font></b></td>
          </tr>
          <%if(rc_bean2.getCust_st().equals("����")){%>
          <tr> 
            <td class=title2 width='90'>����</td>
            <td width="260" align="center">&nbsp;<%=rc_bean2.getCust_nm()%></td>
            <td class=title2 width='90'>�������</td>
            <td width="260" align="center">&nbsp;<%=AddUtil.ChangeEnpH(rc_bean2.getSsn())%></td>
          </tr>
          <%}else{%>
          <tr> 
            <td class=title2 width='90'>��ȣ</td>
            <td align="center">&nbsp;<%=rc_bean2.getFirm_nm()%></td>
            <td class=title2>����ڵ�Ϲ�ȣ</td>
            <td align="center">&nbsp;<%=rc_bean2.getEnp_no()%></td>
          </tr>
          <tr> 
            <td class=title2 width='90'>����</td>
            <td width="260" align="center">&nbsp;<%=rc_bean2.getCust_nm()%></td>
            <td class=title2 width='90'><%if(rc_bean2.getCust_st().equals("����")){%>���ε�Ϲ�ȣ<%}else{%>�������<%}%></td>
            <td width="260" align="center">&nbsp;<%if(rc_bean2.getCust_st().equals("����")){%><%=rc_bean2.getSsn()%><%}else%><%=AddUtil.ChangeEnpH(rc_bean2.getSsn())%><%}%></td>
          </tr>
          <%}%>
        </table>
      </td>
    </tr>
    <tr> 
      <td colspan="3" height="15" align="right"></td>
    </tr>
    <tr> 
      <td class="line" colspan="3"> 
        <table border="1" cellspacing="0" cellpadding="0" width=700 bordercolor="#000000" height="25">
          <tr> 
            <td height="25" bgcolor="#CCCCCC" colspan="6">&nbsp;<b><font size="3">��.��.��.��</font></b></td>
          </tr>
          <tr> 
            <td class=title2 width="90">����</td>
            <td width="180" align="center" >&nbsp;<%=reserv.get("CAR_NM")%>&nbsp;<%=reserv.get("CAR_NAME")%></td>
            <td width="80" align="center" >������ȣ</td>
            <td width="120" align="center" ><%=reserv.get("CAR_NO")%></td>
            <td class=title2 width="90" >��������Ÿ�<br>(������)</td>
            <td align="center" width="140">&nbsp;<%=rs_bean.getRun_km()%>km</td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td colspan="3" height="15" align="right"></td>
    </tr>
    <tr> 
      <td class="line" colspan="3"> 
        <table border="1" cellspacing="0" cellpadding="0" width=700 bordercolor="#000000" height="25">
          <tr> 
            <td height="25" bgcolor="#CCCCCC" colspan="5">&nbsp;<b><font size="3">��.�� 
              / ��.��</font></b></td>
          </tr>
          <tr> 
            <td class=title2 width="90">�����Ͻ�</td>
            <td align="center" colspan="2">&nbsp;<%=AddUtil.ChangeDate3(rc_bean.getDeli_dt())%></td>
            <td class=title2 width='130'>�����Ͻ�</td>
            <td align="center" width="220">&nbsp;<%=AddUtil.ChangeDate3(rc_bean.getRet_dt())%></td>
          </tr>
          <tr> 
            <td class=title2 rowspan="2">�̿�Ⱓ</td>
            <td class=title2 width="130">&nbsp;���ʾ����ð�</td>
            <td class=title2 width="130">�߰��̿�ð�</td>
            <td class=title2 width="130">���̿�ð�</td>
            <td class=title2>&nbsp;���</td>
          </tr>
          <tr> 
            <td align="center" height="22">&nbsp;<input type="text" name="rent_hour" value="<%=rc_bean.getRent_hour()%>" size="1" class=whitenum >
                      �ð� 
                      <input type="text" name="rent_days" value="<%=rc_bean.getRent_days()%>" size="1" class=whitenum >
                      �� 
                      <input type="text" name="rent_months" value="<%=rc_bean.getRent_months()%>" size="1" class=whitenum >
                      ���� </td></td>
            <td align="center">&nbsp;<input type="text" name="add_hour" value="<%=rs_bean.getAdd_hour()%>" size="1" class=whitenum >
                      �ð� 
                      <input type="text" name="add_days" value="<%=rs_bean.getAdd_days()%>" size="1" class=whitenum >
                      �� 
                      <input type="text" name="add_months" value="<%=rs_bean.getAdd_months()%>" size="1" class=whitenum >
                      ���� </td>
            <td align="center">&nbsp;<input type="text" name="tot_hour" value="<%=rs_bean.getTot_hour()%>" size="1" class=whitenum >
                      �ð� 
                      <input type="text" name="tot_days" value="<%=rs_bean.getTot_days()%>" size="1" class=whitenum >
                      �� 
                      <input type="text" name="tot_months" value="<%=rs_bean.getTot_months()%>" size="1" class=whitenum >
                      ���� </td>
            <td align="center">&nbsp;<%=rs_bean.getEtc()%></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td colspan="3" height="15" align="right"></td>
    </tr>
    <tr> 
      <td class="line" colspan="3"> 
        <table border="1" cellspacing="0" cellpadding="0" width=700 bordercolor="#000000" height="25">
          <tr> 
            <td height="25" bgcolor="#CCCCCC" colspan="5">&nbsp;<b><font size="3">��.��.��.��.��.��</font></b></td>
          </tr>
          <tr> 
            <td colspan="5" height="22">&nbsp;1. ����뿩��</td>
          </tr>
          <tr> 
            <td class=title2 width="120">�뿩���Ѿ�</td>
            <td class=title2 width="120">������</td>
            <td class=title2 width="120">������</td>
            <td class=title2 width="120">�Ұ�(��)</td>
            <td class=title2 width="220">�հ�(VAT����)(��)</td>
          </tr>
          <tr> 
            <td align="center">�� 
              <input type="text" name="ag_t_fee_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_s_amt()+ext_pay_rent_s_amt)%>" size="10" class=whitenum>
            </td>
            <td align="center">�� 
              <input type="text" name="ag_cons1_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons1_s_amt())%>" size="10" class=whitenum>
            </td>
            <td align="center"> �� 
              <input type="text" name="ag_cons2_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons2_s_amt())%>" size="10" class=whitenum>
            </td>
            <td align="center"> �� 
              <input type="text" name="ag_tot_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getTot_s_amt()+ext_pay_rent_s_amt)%>" size="10" class=whitenum>
            </td>
            <td align="center" >�� 
              <input type="text" name="ag_tot_amt" value="<%=AddUtil.parseDecimal(rf_bean.getRent_tot_amt()+ext_pay_rent_s_amt+ext_pay_rent_v_amt)%>" size="10" class=whitenum>
            </td>
          </tr>
          <tr> 
            <td colspan="5" height="22">&nbsp;2. �߰��̿� �뿩��</td>
          </tr>
          <tr> 
            <td class=title2>�뿩���Ѿ�</td>
            <td class=title2>������</td>
            <td class=title2>������</td>
            <td class=title2>�Ұ�(��)</td>
            <td class=title2>�հ�(VAT����)(��)</td>
          </tr>
          <tr> 
            <td align="center">�� 
              <input type="text" name="add_fee_s_amt" value="<%=AddUtil.parseDecimal(rs_bean.getAdd_fee_s_amt())%>" size="10" class=whitenum>
            </td>
            <td align="center">�� 
              <input type="text" name="add_cons1_s_amt" value="<%=AddUtil.parseDecimal(rs_bean.getAdd_cons1_s_amt())%>" size="10" class=whitenum>
            </td>
            <td align="center"> �� 
              <input type="text" name="add_cons2_s_amt" value="<%=AddUtil.parseDecimal(rs_bean.getAdd_cons2_s_amt())%>" size="10" class=whitenum>
            </td>
            <td align="center"> �� 
              <input type="text" name="add_tot_s_amt" value="<%=AddUtil.parseDecimal(rs_bean.getAdd_fee_s_amt()+rs_bean.getAdd_cons1_s_amt()+rs_bean.getAdd_cons2_s_amt())%>" size="10" class=whitenum>
            </td>
            <td align="center" >�� 
              <input type="text" name="add_tot_amt" value="<%=AddUtil.parseDecimal(rs_bean.getAdd_fee_s_amt()+rs_bean.getAdd_cons1_s_amt()+rs_bean.getAdd_cons2_s_amt()+rs_bean.getAdd_fee_v_amt()+rs_bean.getAdd_cons1_v_amt()+rs_bean.getAdd_cons2_v_amt())%>" size="10" class=whitenum>
            </td>
          </tr>
          <tr> 
            <td colspan="5" height="22">&nbsp;3. ����뿩��</td>
          </tr>
          <tr> 
            <td class=title2>�뿩���Ѿ�</td>
            <td class=title2>������</td>
            <td class=title2>������</td>
            <td class=title2>�Ұ�(��)</td>
            <td class=title2>�հ�(VAT����)(��)</td>
          </tr>
          <tr> 
            <td align="center">�� 
              <input type="text" name="tot_fee_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_s_amt()+ext_pay_rent_s_amt+rs_bean.getAdd_fee_s_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
            </td>
            <td align="center">�� 
              <input type="text" name="tot_cons1_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons1_s_amt()+rs_bean.getAdd_cons1_s_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
            </td>
            <td align="center"> �� 
              <input type="text" name="tot_cons2_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons2_s_amt()+rs_bean.getAdd_cons2_s_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
            </td>
            <td align="center"> �� 
              <input type="text" name="rent_tot_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getTot_s_amt()+ext_pay_rent_s_amt+rs_bean.getAdd_fee_s_amt()+rs_bean.getAdd_cons1_s_amt()+rs_bean.getAdd_cons2_s_amt())%>" size="10" class=whitenum>
            </td>
            <td align="center" >�� 
              <input type="text" name="rent_tot_amt" value="<%=AddUtil.parseDecimal(rf_bean.getRent_tot_amt()+ext_pay_rent_s_amt+ext_pay_rent_v_amt+rs_bean.getAdd_fee_s_amt()+rs_bean.getAdd_cons1_s_amt()+rs_bean.getAdd_cons2_s_amt()+rs_bean.getAdd_fee_v_amt()+rs_bean.getAdd_cons1_v_amt()+rs_bean.getAdd_cons2_v_amt())%>" size="10" class=whitenum>
            </td>
          </tr>          
          <tr> 
            <td height="22" colspan="4">&nbsp;4. �δ���</td>
            <td height="22">&nbsp;5. �����</td>
          </tr>
          <tr> 
            <td class=title2>�����</td>
            <td class=title2>��å��</td>
            <td class=title2>������</td>
            <td class=title2>�Ұ�(��)</td>
            <td class=title2>�հ�(VAT����)(��+��)</td>
          </tr>
          <tr> 
            <td align="center">�� 
              <input type="text" name="cls_amt" value="<%=AddUtil.parseDecimal(rs_bean.getCls_s_amt()+rs_bean.getCls_v_amt())%>" size="10" class=whitenum>
            </td>
            <td align="center">�� 
              <input type="text" name="ins_m_amt" value="<%=AddUtil.parseDecimal(rs_bean.getIns_m_s_amt()+rs_bean.getIns_m_v_amt())%>" size="10" class=whitenum>
            </td>
            <td align="center"> �� 
              <input type="text" name="ins_h_amt" value="<%=AddUtil.parseDecimal(rs_bean.getIns_h_s_amt()+rs_bean.getIns_h_v_amt())%>" size="10" class=whitenum>
            </td>
            <td rowspan="3" align="center"> �� 
              <input type="text" name="etc_tot_amt" value="<%=AddUtil.parseDecimal(rs_bean.getCls_s_amt()+rs_bean.getCls_v_amt()+rs_bean.getIns_m_s_amt()+rs_bean.getIns_m_v_amt()+rs_bean.getIns_h_s_amt()+rs_bean.getIns_h_v_amt()+rs_bean.getOil_s_amt()+rs_bean.getOil_v_amt()+rs_bean.getKm_s_amt()+rs_bean.getKm_v_amt()+rs_bean.getFine_s_amt())%>" size="10" class=whitenum>              
            </td>
            <td rowspan="3" align="center" >�� 
              <input type="text" name="s_rent_tot_amt" value="<%=AddUtil.parseDecimal(rs_bean.getAdd_fee_s_amt()+rs_bean.getAdd_cons1_s_amt()+rs_bean.getAdd_cons2_s_amt()+rs_bean.getAdd_fee_v_amt()+rs_bean.getAdd_cons1_v_amt()+rs_bean.getAdd_cons2_v_amt()+rs_bean.getCls_s_amt()+rs_bean.getCls_v_amt()+rs_bean.getIns_m_s_amt()+rs_bean.getIns_m_v_amt()+rs_bean.getIns_h_s_amt()+rs_bean.getIns_h_v_amt()+rs_bean.getOil_s_amt()+rs_bean.getOil_v_amt()+rs_bean.getKm_s_amt()+rs_bean.getKm_v_amt()+rs_bean.getFine_s_amt())%>" size="10" class=whitenum>              
            </td>
          </tr>          
          <tr> 
            <td class=title2>������</td>
            <td class=title2>KM�ʰ�����</td>
            <td class=title2>�̼����·�</td>
          </tr>
          <tr> 
            <td align="center">�� 
              <input type="text" name="oil_amt" value="<%=AddUtil.parseDecimal(rs_bean.getOil_s_amt()+rs_bean.getOil_v_amt())%>" size="10" class=whitenum>
            </td>
            <td align="center">�� 
              <input type="text" name="km_amt" value="<%=AddUtil.parseDecimal(rs_bean.getKm_s_amt()+rs_bean.getKm_v_amt())%>" size="10" class=whitenum>
            </td>
            <td align="center"> �� 
              <input type="text" name="fine_s_amt" value="<%=AddUtil.parseDecimal(rs_bean.getFine_s_amt())%>" size="10" class=whitenum>
            </td>
          </tr>

        </table>
      </td>
    </tr>
    <tr> 
      <td colspan="3" height="15" align="right"></td>
    </tr>
    <tr> 
      <td colspan="3" height="5"> 
        <table border="1" cellspacing="0" cellpadding="0" width=700 bordercolor="#000000" height="25">
          <tr> 
            <td height="25" colspan="3" bgcolor="#CCCCCC">&nbsp;<b><font size="3">��.��.��</font></b></td>
            <td height="25" bgcolor="#CCCCCC">&nbsp;<b><font size="3">��.��.ä.��</font></b></td>
          </tr>
          <tr> 
            <td class=title2 width="120">�ݾ�</td>
            <td class=title2 width="120">��������</td>
            <td class=title2 width="120">�������</td>
            <td class=title2 width="340">�ݾ�</td>
          </tr>
          <tr> 
            <td class=title2>��
            <input type="text" name="grt_amt" value="<%=AddUtil.parseDecimal(sr_bean6.getPay_amt())%>" size="10" class=whitenum></td>
            <td class=title2><%=AddUtil.ChangeDate2(sr_bean6.getPay_dt())%></td>
            <td class=title2>
              <%if(!sr_bean6.getPay_dt().equals("")){%>
                <%if(sr_bean6.getPaid_st().equals("1")){%>
                �ſ�ī��  
                <%}else if(sr_bean6.getPaid_st().equals("2")){%>
                ����
                <%}else if(sr_bean6.getPaid_st().equals("3")){%>
                �ڵ���ü
                <%}else if(sr_bean6.getPaid_st().equals("3")){%>
                �������Ա�
                <%}%>
              <%}%>  
            </td>
            <td class=title2>��
            <input type="text" name="no_pay_rent_amt" value="<%=AddUtil.parseDecimal(no_pay_rent_amt)%>" size="10" class=whitenum></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td colspan="3" height="15" align="right"></td>
    </tr>
    <tr> 
      <td colspan="3"> 
        <table border="1" cellspacing="0" cellpadding="0" width=700 bordercolor="#000000" height="25">
          <tr align="center"> 
            <td height="25" bgcolor="#CCCCCC" colspan="5">&nbsp;<b><font size="3">������ �����Ͻ� �ݾ� : 
              �ϱ� <input type="text" name="rent_sett_amt_text" value="" size="20" class=titlenum>&nbsp;����&nbsp;(��<input type="text" name="rent_sett_amt" value="" size="10" class=titlenum>)</font></b>
              <font size="1">(�����-������+�̼�ä��)</font>
              </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td height="20">&nbsp;</td>
      <td colspan="2" height="20" valign="bottom">&nbsp;</td>
    </tr>
    <tr> 
      <td height="20">&nbsp;</td>
      <td colspan="2" height="20" align="right">&nbsp;<%=AddUtil.ChangeDate2(rs_bean.getSett_dt())%></td>
    </tr>
    <tr> 
      <td class=line height="20">(��)�Ƹ���ī</td>
      <td class=line colspan="2" height="20">&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="3"><font size="1">* �ּ� : ����� �������� ���ǵ��� 17-3 / www.amazoncar.co.kr</font></td>
    </tr>
    <tr> 
      <td colspan="3"><font size="1">* TEL : 02-757-0802(������), 02-392-4243(�ѹ���), 02-392-4242(������), 02-537-5877(��������), 051-851-0606(�λ�����),<br>
      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;042-824-1770(��������), 053-582-2998(�뱸����), 062-385-0133(��������)</font></td>
    </tr>
  </table>
</form>
<script language='javascript'>
<!--
	var fm = document.form1;
	
	<%if(rent_st.equals("12") && ext_size > 0){
    		for(int i = 0 ; i < ext_size ; i++){
    			Hashtable ext = (Hashtable)exts.elementAt(i);
    			if(AddUtil.parseInt(String.valueOf(ext.get("PAY_AMT"))) > 0){
    	%>	
    				fm.rent_months.value 	= toInt(fm.rent_months.value)	+ <%=ext.get("RENT_MONTHS")%>;
    				fm.rent_days.value 	= toInt(fm.rent_days.value)	+ <%=ext.get("RENT_DAYS")%>;
    	<%		}
    		}
    	  }
    	%>	
    		
	fm.rent_sett_amt.value 	= parseDecimal(toInt(parseDigit(fm.s_rent_tot_amt.value)) - toInt(parseDigit(fm.grt_amt.value)) + toInt(parseDigit(fm.no_pay_rent_amt.value)));
	
	//�ݾ� : �������Ŀ��� ������������ ��ȯ
	var amt = parseDigit(fm.rent_sett_amt.value);

	if(amt.length > 0){
		var str = '';
		for(i=amt.length-1; i>=0; i--){
			if(amt.charAt(i) != 0 && amt.length-i == 1) str = AmtChang(amt.charAt(i))+'';
			if(amt.charAt(i) != 0 && amt.length-i == 2) str = AmtChang(amt.charAt(i))+'��' + str;
			if(amt.charAt(i) != 0 && amt.length-i == 3) str = AmtChang(amt.charAt(i))+'��' + str;
			if(amt.charAt(i) != 0 && amt.length-i == 4) str = AmtChang(amt.charAt(i))+'õ' + str;
			if(amt.charAt(i) != 0 && amt.length-i == 5) str = AmtChang(amt.charAt(i))+'��' + str;
			if(amt.charAt(i) == 0 && amt.length-i == 5) str = '��' + str;
			if(amt.charAt(i) != 0 && amt.length-i == 6) str = AmtChang(amt.charAt(i))+'��' + str;
			if(amt.charAt(i) != 0 && amt.length-i == 7) str = AmtChang(amt.charAt(i))+'��' + str;		
			if(amt.charAt(i) != 0 && amt.length-i == 8) str = AmtChang(amt.charAt(i))+'õ' + str;				
		}
		fm.rent_sett_amt_text.value = str;
		//fm.rent_sett_amt.value = parseDecimal(amt);
	}
		
	function AmtChang(str){
		if(str == '1')	str = '��';
		if(str == '2')	str = '��';
		if(str == '3')	str = '��';
		if(str == '4')	str = '��';
		if(str == '5')	str = '��';
		if(str == '6')	str = '��';
		if(str == '7')	str = 'ĥ';
		if(str == '8')	str = '��';
		if(str == '9')	str = '��';
		return str;
	}
//-->
</script>
</body>
</html>
