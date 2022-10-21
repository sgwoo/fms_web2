<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.res_search.*, acar.util.*, acar.car_service.*, acar.serv_off.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="s_bean" class="acar.car_service.ServiceBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>�ڵ����뿩������꼭</title>
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
	//�ܱ�뿩��������
	RentSettleBean rs_bean = rs_db.getRentSettleCase(s_cd);
	//�뿪�������
	ScdDrivBean sd_bean1 = rs_db.getScdDrivCase(s_cd, "1");
	ScdDrivBean sd_bean2 = rs_db.getScdDrivCase(s_cd, "2");
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
            <td class=title width='80' align="center">���������</td>
            <td width="150" align="center" >&nbsp;<%=c_db.getNameById(rc_bean.getRet_mng_id(), "USER")%></td>
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
            <td height="25" bgcolor="#CCCCCC" colspan="4">&nbsp;<b><font size="3">��.��.��.��</font></b></td>
          </tr>
          <tr> 
            <td class=title2 width='90'>����</td>
            <td width="260" align="center">&nbsp;<%=rc_bean2.getCust_nm()%></td>
            <td class=title2 width='90'>�������</td>
            <td width="260" align="center">&nbsp;<%=AddUtil.ChangeEnpH(rc_bean2.getSsn())%></td>
          </tr>
          <tr> 
            <td class=title2 width='90'>��ȣ</td>
            <td align="center">&nbsp;<%=rc_bean2.getFirm_nm()%></td>
            <td class=title2>����ڵ�Ϲ�ȣ</td>
            <td align="center">&nbsp;<%=rc_bean2.getEnp_no()%></td>
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
      <td colspan="3" height="5" align="right"></td>
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
            <td class=title2 width="130">�հ�</td>
            <td class=title2>&nbsp;���</td>
          </tr>
          <tr> 
            <td align="center" height="22">&nbsp;<%=rc_bean.getRent_hour()%>�ð�<%=rc_bean.getRent_days()%>��<%=rc_bean.getRent_months()%>����</td>
            <td align="center">&nbsp;<%=rs_bean.getAdd_hour()%>�ð�<%=rs_bean.getAdd_days()%>��<%=rs_bean.getAdd_months()%>����</td>
            <td align="center">&nbsp;<%=rs_bean.getTot_hour()%>�ð�<%=rs_bean.getTot_days()%>��<%=rs_bean.getTot_months()%>����</td>
            <td align="center">&nbsp;<%=rs_bean.getEtc()%></td>
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
            <td height="25" bgcolor="#CCCCCC" colspan="5">&nbsp;<b><font size="3">��.��.��.��.��.��</font></b></td>
          </tr>
          <tr> 
            <td colspan="5" height="22">&nbsp;1. ����뿩��</td>
          </tr>
          <tr> 
            <td class=title2 width="120">���ʴ뿩��</td>
            <td class=title2 width="120">���ú����</td>
            <td class=title2 width="120">��Ÿ���</td>
            <td class=title2 width="120">�Ұ�(��)</td>
            <td class=title2 width="220">�հ�(VAT����)(��)</td>
          </tr>
          <tr> 
            <td align="center">�� 
              <input type="text" name="ag_fee_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_s_amt()-rf_bean.getDc_s_amt())%>" size="10" class=whitenum>
            </td>
            <td align="center">�� 
              <input type="text" name="ag_ins_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getIns_s_amt())%>" size="10" class=whitenum>
            </td>
            <td align="center"> �� 
              <input type="text" name="ag_etc_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getEtc_s_amt()+rf_bean.getCons1_s_amt()+rf_bean.getCons2_s_amt())%>" size="10" class=whitenum>
            </td>
            <td align="center"> �� 
              <input type="text" name="ag_tot_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getTot_s_amt())%>" size="10" class=whitenum>
            </td>
            <td align="center" >�� 
              <input type="text" name="ag_tot_amt" value="<%=AddUtil.parseDecimal(rf_bean.getRent_tot_amt())%>" size="10" class=whitenum>
            </td>
          </tr>
          <tr> 
            <td colspan="5" height="22">&nbsp;2. �߰��̿� �뿩��</td>
          </tr>
          <tr> 
            <td class=title2>�뿩��</td>
            <td class=title2>���ú����</td>
            <td class=title2>��Ÿ���</td>
            <td class=title2>�Ұ�(��)</td>
            <td class=title2>�հ�(VAT����)(��)</td>
          </tr>
          <tr> 
            <td align="center">�� 
              <input type="text" name="add_fee_s_amt" value="<%=AddUtil.parseDecimal(rs_bean.getAdd_fee_s_amt())%>" size="10" class=whitenum>
            </td>
            <td align="center">�� 
              <input type="text" name="add_ins_s_amt" value="<%=AddUtil.parseDecimal(rs_bean.getAdd_ins_s_amt())%>" size="10" class=whitenum>
            </td>
            <td align="center"> �� 
              <input type="text" name="add_etc_s_amt" value="<%=AddUtil.parseDecimal(rs_bean.getAdd_etc_s_amt()+rs_bean.getAdd_cons1_s_amt()+rs_bean.getAdd_cons2_s_amt())%>" size="10" class=whitenum>
            </td>
            <td align="center"> �� 
              <input type="text" name="add_tot_s_amt" value="<%=AddUtil.parseDecimal(rs_bean.getAdd_fee_s_amt()+rs_bean.getAdd_ins_s_amt()+rs_bean.getAdd_etc_s_amt()+rs_bean.getAdd_cons1_s_amt()+rs_bean.getAdd_cons2_s_amt())%>" size="10" class=whitenum>
            </td>
            <td align="center" >�� 
              <input type="text" name="add_tot_amt" value="<%=AddUtil.parseDecimal(rs_bean.getAdd_fee_s_amt()+rs_bean.getAdd_fee_v_amt()+rs_bean.getAdd_ins_s_amt()+rs_bean.getAdd_etc_s_amt()+rs_bean.getAdd_etc_v_amt()+rs_bean.getAdd_cons1_s_amt()+rs_bean.getAdd_cons2_s_amt()+rs_bean.getAdd_cons1_v_amt()+rs_bean.getAdd_cons2_v_amt())%>" size="10" class=whitenum>
            </td>
          </tr>
          <tr> 
            <td colspan="5" height="22">&nbsp;3. �δ���</td>
          </tr>
          <tr> 
            <td class=title2>��å��</td>
            <td class=title2>������</td>
            <td class=title2>������</td>
            <td class=title2>�Ұ�(��)</td>
            <td class=title2>�հ�(VAT����)(��)</td>
          </tr>
          <tr> 
            <td align="center">�� 
              <input type="text" name="ins_m_s_amt" value="<%=AddUtil.parseDecimal(rs_bean.getIns_m_s_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
            </td>
            <td align="center">�� 
              <input type="text" name="ins_h_s_amt" value="<%=AddUtil.parseDecimal(rs_bean.getIns_h_s_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
            </td>
            <td align="center"> �� 
              <input type="text" name="oil_s_amt" value="<%=AddUtil.parseDecimal(rs_bean.getOil_s_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
            </td>
            <td align="center"> �� 
              <input type="text" name="etc_tot_s_amt" value="<%=AddUtil.parseDecimal(rs_bean.getIns_m_s_amt()+rs_bean.getIns_h_s_amt()+rs_bean.getOil_s_amt())%>" size="10" class=whitenum>
            </td>
            <td align="center" >�� 
              <input type="text" name="etc_tot_amt" value="<%=AddUtil.parseDecimal(rs_bean.getIns_m_s_amt()+rs_bean.getIns_m_v_amt()+rs_bean.getIns_h_s_amt()+rs_bean.getIns_h_v_amt()+rs_bean.getOil_s_amt()+rs_bean.getOil_v_amt())%>" size="10" class=whitenum>
            </td>
          </tr>
          <tr> 
            <td colspan="5" height="22">&nbsp;4. ����뿩��</td>
          </tr>
          <tr> 
            <td class=title2>�뿩��</td>
            <td class=title2>���ú����</td>
            <td class=title2>��Ÿ���</td>
            <td class=title2>�Ұ�(��+��+��)</td>
            <td class=title2>�հ�(VAT����)(��+��+��)</td>
          </tr>
          <tr> 
            <td align="center">�� 
              <input type="text" name="tot_fee_s_amt" value="" size="10" class=whitenum>
            </td>
            <td align="center">�� 
              <input type="text" name="tot_ins_s_amt" value="" size="10" class=whitenum>
            </td>
            <td align="center"> �� 
              <input type="text" name="tot_etc_s_amt" value="" size="10" class=whitenum>
            </td>
            <td align="center"> �� 
              <input type="text" name="rent_tot_s_amt" value="" size="10" class=whitenum>
            </td>
            <td align="center" >�� 
              <input type="text" name="s_rent_tot_amt" value="" size="10" class=whitenum>
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
            <td height="25" bgcolor="#CCCCCC" colspan="5">&nbsp;<b><font size="3">��.��.�� 
              / ��.��.��</font></b></td>
          </tr>
          <tr> 
            <td class=title2 width="90">&nbsp;</td>
            <td class=title2 width="120">&nbsp;���ຸ����</td>
            <td class=title2 width="120">������</td>
            <td class=title2 width='120'>����</td>
            <td class=title2 width="250">&nbsp;���</td>
          </tr>
          <tr> 
            <td class=title2 width="90">�ݾ�</td>
            <td align="center" width="120">&nbsp;�� 
              <input type="text" name="pay_amt1" value="<%=AddUtil.parseDecimal(sr_bean1.getPay_amt())%>" size="10" class=whitenum>
            </td>
            <td align="center" width="120">�� 
              <input type="text" name="pay_amt2" value="<%=AddUtil.parseDecimal(sr_bean2.getPay_amt())%>" size="10" class=whitenum>
            </td>
            <td align="center" width="120">�� 
              <input type="text" name="rest_amt2" value="<%=AddUtil.parseDecimal(sr_bean2.getRest_amt())%>" size="10" class=whitenum>
            </td>
            <td rowspan="3" width="248"> 
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td width="70" height="16">* ���ຸ����</td>
                  <td height="16">: �뿩���� 10%�̻�</td>
                </tr>
                <tr> 
                  <td width="70" height="16">* ������</td>
                  <td height="16">: �뿩�� ����(������)</td>
                </tr>
                <tr> 
                  <td colspan="2" height="16">* �뿪��� ���� ���� �Աݵ��� �ʽ��ϴ�.</td>
                </tr>
              </table>
            </td>
          </tr>
          <tr> 
            <td class=title2 width="90">��������</td>
            <td align="center" height="22" width="120">&nbsp;<%=AddUtil.ChangeDate2(sr_bean1.getPay_dt())%></td>
            <td align="center" width="120">&nbsp;<%=AddUtil.ChangeDate2(sr_bean1.getPay_dt())%></td>
            <td align="center" width="120">-</td>
          </tr>
          <tr> 
            <td class=title2 width="90">�������</td>
            <td align="center" height="22" width="120">&nbsp;
			<%if(sr_bean1.getPaid_st().equals("1")){%>�ſ�ī��<%}%>
			<%if(sr_bean1.getPaid_st().equals("2")){%>����<%}%>
			<%if(sr_bean1.getPaid_st().equals("3")){%>�ڵ���ü<%}%>						
			</td>
            <td align="center" width="120">&nbsp;
			<%if(sr_bean2.getPaid_st().equals("1")){%>�ſ�ī��<%}%>
			<%if(sr_bean2.getPaid_st().equals("2")){%>����<%}%>
			<%if(sr_bean2.getPaid_st().equals("3")){%>�ڵ���ü<%}%>									
			</td>
            <td align="center" width="120">-</td>
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
            <td height="25" bgcolor="#CCCCCC" colspan="5">&nbsp;<b><font size="3">��.��.��.��(�������)</font></b></td>
          </tr>
          <tr> 
            <td class=title2 width="210" >������</td>
            <td class=title2 width="90">&nbsp;</td>
            <td class=title2 width="120">�Ա�</td>
            <td width="120" class=title2>OT/��Ÿ</td>
            <td class=title2 width="160" >�հ�&nbsp; </td>
          </tr>
          <tr> 
            <td class=title2 rowspan="3" > 
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td height="16"> 
                    <input type="radio" name="driv_serv_st" value="radiobutton" <%if(rs_bean.getDriv_serv_st().equals("1"))%>chechked<%%>>
                    �Ҽӿ뿪ȸ��� ���� ����</td>
                </tr>
                <tr> 
                  <td height="16"> 
                    <input type="radio" name="driv_serv_st" value="radiobutton" <%if(rs_bean.getDriv_serv_st().equals("2"))%>chechked<%%>>
                    �뿩�� ����� �ջ�</td>
                </tr>
                <tr> 
                  <td height="16">&nbsp; </td>
                </tr>
              </table>
            </td>
            <td class=title2 width="150">�ݾ�</td>
            <td align="center" >�� 
              <input type="text" name="d_pay_amt1" value="<%=AddUtil.parseDecimal(sd_bean1.getPay_amt())%>" size="10" class=whitenum>
            </td>
            <td align="center">�� 
              <input type="text" name="d_pay_amt2" value="<%=AddUtil.parseDecimal(sd_bean2.getPay_amt())%>" size="10" class=whitenum>
            </td>
            <td align="center">�� 
              <input type="text" name="d_pay_tot_amt" value="<%=AddUtil.parseDecimal(sd_bean1.getPay_amt()+sd_bean2.getPay_amt())%>" size="10" class=whitenum>
            </td>
          </tr>
          <tr> 
            <td class=title2 width="150">��������</td>
            <td align="center">&nbsp;<%=AddUtil.ChangeDate2(sd_bean1.getPay_dt())%></td>
            <td align="center">&nbsp;<%=AddUtil.ChangeDate2(sd_bean2.getPay_dt())%></td>
            <td align="center">-</td>
          </tr>
          <tr> 
            <td class=title2 width="150">��������</td>
            <td align="center">&nbsp;
			<%if(sd_bean1.getPaid_st().equals("1")){%>�ſ�ī��<%}%>
			<%if(sd_bean1.getPaid_st().equals("2")){%>����<%}%>
			<%if(sd_bean1.getPaid_st().equals("3")){%>�ڵ���ü<%}%>						
			</td>
            <td align="center">&nbsp;
			<%if(sd_bean2.getPaid_st().equals("1")){%>�ſ�ī��<%}%>
			<%if(sd_bean2.getPaid_st().equals("2")){%>����<%}%>
			<%if(sd_bean2.getPaid_st().equals("3")){%>�ڵ���ü<%}%>									
			</td>
            <td align="center">-</td>
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
            <td height="25" bgcolor="#CCCCCC" colspan="5">&nbsp;<b><font size="3">�� 
              ����� : �ϱ� <input type="text" name="rent_sett_amt_text" value="" size="35" class=titlenum>&nbsp;����&nbsp;(��<input type="text" name="rent_sett_amt" value="" size="10" class=titlenum>)</font></b></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td height="20">&nbsp;</td>
      <td colspan="2" height="20" valign="bottom">&nbsp;</td>
    </tr>
    <tr> 
      <td height="15">&nbsp;</td>
      <td colspan="2" height="15" valign="bottom">��� �ݾ��� ���� ���� ��.</td>
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
      <td colspan="3"><font size="1">* �ּ� : ����� �������� ���ǵ��� 17-3 / TEL.02-757-0802(������), 
        02-392-4243(�ѹ���), 02-392-4242(������), www.amazoncar.co.kr</font></td>
    </tr>
  </table>
</form>
<script language='javascript'>
<!--
	var fm = document.form1;
	fm.tot_fee_s_amt.value 	= parseDecimal(toInt(parseDigit(fm.ag_fee_s_amt.value)) + toInt(parseDigit(fm.add_fee_s_amt.value)));
	fm.tot_ins_s_amt.value 	= parseDecimal(toInt(parseDigit(fm.ag_ins_s_amt.value)) + toInt(parseDigit(fm.add_ins_s_amt.value)));
	fm.tot_etc_s_amt.value 	= parseDecimal(toInt(parseDigit(fm.ag_etc_s_amt.value)) + toInt(parseDigit(fm.add_etc_s_amt.value)) + toInt(parseDigit(fm.etc_tot_s_amt.value)));
	fm.rent_tot_s_amt.value = parseDecimal(toInt(parseDigit(fm.ag_tot_s_amt.value)) + toInt(parseDigit(fm.add_tot_s_amt.value)) + toInt(parseDigit(fm.etc_tot_s_amt.value)));
	fm.s_rent_tot_amt.value = parseDecimal(toInt(parseDigit(fm.ag_tot_amt.value)) + toInt(parseDigit(fm.add_tot_amt.value)) + toInt(parseDigit(fm.etc_tot_amt.value)));
	fm.rent_sett_amt.value 	= parseDecimal(toInt(parseDigit(fm.s_rent_tot_amt.value)) - toInt(parseDigit(fm.pay_amt1.value)) - toInt(parseDigit(fm.pay_amt2.value)) + toInt(parseDigit(fm.d_pay_tot_amt.value)));
	
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
		fm.rent_sett_amt.value = parseDecimal(amt);
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
