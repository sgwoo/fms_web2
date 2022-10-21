<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.estimate_mng.*, acar.car_register.*"%>
<%@ page import="acar.car_office.*, acar.user_mng.*, acar.cls.*, acar.con_tax.*, acar.insur.* "%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st 		= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	if(base.getCar_gu().equals("")) base.setCar_gu(base.getReg_id());
	
	//����Ÿ����
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//����,�����
	Hashtable mgrs = a_db.getCommiNInfo(rent_mng_id, rent_l_cd);
	Hashtable mgr_bus = (Hashtable)mgrs.get("BUS");
	Hashtable mgr_dlv = (Hashtable)mgrs.get("DLV");
	
	//�����⺻����
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//�ڵ����⺻����
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//�����������
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	CarChaBean cha1 = crd.getCarCha(base.getCar_mng_id(),"1");
	CarChaBean cha2 = crd.getCarCha(base.getCar_mng_id(),"2");
	
	//�������
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	//�Һ�����
	ContDebtBean debt = a_db.getContDebt(rent_mng_id, rent_l_cd);
	
	//�뿩�᰹����ȸ(���忩��)
	int fee_size 	= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	//�ش�뿩����
	ContFeeBean fee 	= a_db.getContFeeNew(rent_mng_id, rent_l_cd, rent_st);
	//ù�뿩����
	ContFeeBean f_fee 	= a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	//�������뿩����
	ContFeeBean l_fee 	= a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	//�����⺻����
	ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, rent_st);
	
	String taecha_no  	= request.getParameter("taecha_no")==null?"":request.getParameter("taecha_no");
	
	if(taecha_no.equals("")){
		taecha_no = a_db.getMaxTaechaNo(rent_mng_id, rent_l_cd)+"";
	}
			
	//�����������
	ContTaechaBean taecha = a_db.getTaecha(rent_mng_id, rent_l_cd, taecha_no);
	
	
	//��������
	ClsBean cls = as_db.getClsCase(rent_mng_id, rent_l_cd);
	
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
<table border=0 cellspacing=0 cellpadding=0 width=1000>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td colspan="2" class=title style="font-size : 8pt;">����ȣ</td>
                    <td class=title width=10% style="font-size : 8pt;">������ȣ</td>
                    <td width="10%" colspan="4" rowspan="2" align="center" style="font-size : 15pt;">������</td>
                    <td class=title width=10% style="font-size : 8pt;">������ȣ</td>
                    <td class=title width=10% style="font-size : 8pt;">������</td>
                    <td class=title width=10% style="font-size : 8pt;">����å����</td>
                </tr>
                <tr>
                  <td colspan="2" align="center"><%=rent_l_cd%></td>
                  <td width=10% align="center"><b><font color='#990000'><%=cr_bean.getCar_no()%></font></b></td>
                  <td align="center"><%=cr_bean.getCar_doc_no()%></td>
                  <td align="center"><%=c_db.getNameById(base.getBus_id(),"USER")%></td>
                  <td align="center"><%=c_db.getNameById(fee_etc.getChk_id(),"USER")%></td>
                </tr>
                <tr>
                  <td width="10%" rowspan="2" class=title style="font-size : 8pt;">�����</td>
                  <td width="10%" rowspan="2" align="center"><b><font color='#990000'><%=client.getFirm_nm()%></font></b></td>
                  <td colspan="4" class=title style="font-size : 8pt;">�������</td>
                  <td colspan="4" class=title style="font-size : 8pt;">��������</td>
                </tr>
                <tr>
                  <td width="10%" class=title style="font-size : 8pt;">�뿩����</td>
                  <td width="10%" class=title style="font-size : 8pt;">�뿩����</td>
                  <td width="10%" class=title style="font-size : 8pt;">�������</td>
                  <td width="10%" class=title style="font-size : 8pt;">���谡�Կ���</td>
                  <td width="10%" class=title style="font-size : 8pt;">�������</td>
                  <td width="10%" class=title style="font-size : 8pt;">�Һ�����</td>
                  <td width="10%" class=title style="font-size : 8pt;">�Һ�����</td>
                  <td width="10%" class=title style="font-size : 8pt;">��������</td>
                </tr>
                <tr>
                  <td class=title style="font-size : 8pt;">����</td>
                  <td align="center"><%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%></td>
                  <td align="center"><%String car_st = base.getCar_st();%>
                    <%if(car_st.equals("1")){%>
                    ��Ʈ
                    <%}else if(car_st.equals("2")){%>
                    ����
                    <%}else if(car_st.equals("3")){%>
                    ����
                  <%}%></td>
                  <td align="center"><%String rent_way = fee.getRent_way();%>
                    <%if(rent_way.equals("1")){%>
                    �Ϲݽ�
                    <%}else if(rent_way.equals("3")){%>
                    �⺻��
                  <%}%></td>
                  <td align="center"><%String car_ext = car.getCar_ext();%><%=c_db.getNameByIdCode("0032", "", car_ext)%></td>
                  <td align="center"><%String driving_age = base.getDriving_age();%>
                  <%if(driving_age.equals("0")){%>26���̻�<%}
                  else if(driving_age.equals("3")){%>24���̻�<%}
                  else if(driving_age.equals("1")){%>21���̻�<%}
                  else if(driving_age.equals("2")){%>��������<%}
                  else if(driving_age.equals("5")){%>30���̻�<%}
                  else if(driving_age.equals("6")){%>35���̻�<%}
                  else if(driving_age.equals("7")){%>43���̻�<%}
                  else if(driving_age.equals("8")){%>48���̻�<%}
                  else if(driving_age.equals("9")){%>22���̻�<%}
                  else if(driving_age.equals("10")){%>28���̻�<%}
                  else if(driving_age.equals("11")){%>35���̻�~49������<%}%>
                  </td>
                  <td align="center"><%=c_db.getNameById(debt.getCpt_cd(), "BANK")%></td>
                  <td align="center"><%if(!debt.getCpt_cd().equals("")){%><%=AddUtil.parseDecimal(debt.getLend_prn())%>��<br>/ <%=debt.getTot_alt_tm()%>����<%}%></td>
                  <td align="center"><%if(!debt.getCpt_cd().equals("")){%><%if(debt.getLend_id().equals("")){%>����<%}else{%>����<%}%><%}%></td>
                  <td align="center"><%=AddUtil.ChangeDate2(debt.getLend_dt())%></td>
                </tr>
                <tr>
                  <td class=title style="font-size : 8pt;">�������</td>
                  <td align="center"><%=AddUtil.ChangeDate2(base.getRent_dt())%></td>
                  <td align="center">&nbsp;</td>
                  <td align="center">&nbsp;</td>
                  <td align="center">&nbsp;</td>
                  <td align="center">&nbsp;</td>
                  <td align="center">&nbsp;</td>
                  <td align="center">&nbsp;</td>
                  <td align="center">&nbsp;</td>
                  <td align="center">&nbsp;</td>
                </tr>
                <tr>
                  <td class=title style="font-size : 8pt;">�������</td>
                  <td align="center"><%=AddUtil.ChangeDate2(base.getDlv_dt())%></td>
                  <td colspan="4" class=title style="font-size : 8pt;">ä�Ǽ���</td>
                  <td colspan="4" class=title style="font-size : 8pt;">�ڵ��������缳��</td>
                </tr>
                <tr>
                  <td class=title style="font-size : 8pt;">�������</td>
				  <td align="center"><%=cr_bean.getInit_reg_dt()%></td>
                  <td class=title style="font-size : 8pt;">����</td>                  
                  <td class=title style="font-size : 8pt;">�ϰ�����</td>
                  <td class=title style="font-size : 8pt;">Ȯ����</td>
                  <td class=title style="font-size : 8pt;">���</td>
                  <td class=title style="font-size : 8pt;">�������</td>
                  <td class=title style="font-size : 8pt;">ä�ǰ���</td>
                  <td class=title style="font-size : 8pt;">��������</td>
                  <td class=title style="font-size : 8pt;">��������</td>
                </tr>
                <tr>
                  <td class=title style="font-size : 8pt;">�ε�����</td>
                  <td align="center"><%=AddUtil.ChangeDate2(f_fee.getRent_start_dt())%></td>
                  <td class=title style="font-size : 8pt;">���뺸����</td>
                  <td align="center">&nbsp;</td>
                  <td align="center">&nbsp;</td>
                  <td align="center">&nbsp;</td>
                  <td align="center">&nbsp;</td>
                  <td align="center">&nbsp;</td>
                  <td align="center">&nbsp;</td>
                  <td align="center">&nbsp;</td>
                </tr>
                <tr>
                  <td class=title style="font-size : 8pt;">���Ⱓ</td>
                  <td align="center">&nbsp;<%=fee.getCon_mon()%>����</td>
                  <td class=title style="font-size : 8pt;">��������</td>
                  <td align="center">&nbsp;</td>
                  <td align="center">&nbsp;</td>
                  <td align="center">&nbsp;</td>
                  <td align="center">&nbsp;</td>
                  <td align="center">&nbsp;</td>
                  <td align="center">&nbsp;</td>
                  <td align="center">&nbsp;</td>
                </tr>
                <tr>
                  <td class=title style="font-size : 8pt;">��ళ����</td>
                  <td align="center"><%=AddUtil.ChangeDate2(f_fee.getRent_start_dt())%></td>
                  <td class=title style="font-size : 8pt;">������������</td>
                  <td align="center">&nbsp;</td>
                  <td align="center">&nbsp;</td>
                  <td align="center">&nbsp;</td>
                  <td align="center">&nbsp;</td>
                  <td align="center">&nbsp;</td>
                  <td align="center">&nbsp;</td>
                  <td align="center">&nbsp;</td>
                </tr>
                <tr>
                  <td class=title style="font-size : 8pt;">��ุ����</td>
                  <td align="center"><%=AddUtil.ChangeDate2(l_fee.getRent_end_dt())%></td>
                  <td class=title style="font-size : 8pt;" colspan="2">LPG����</td>
                  <td class=title style="font-size : 8pt;" colspan="2">LPGŻ��</td>
                  <td class=title style="font-size : 8pt;" colspan="4">�����������</td>
                </tr>
                <tr>
                  <td class=title style="font-size : 8pt;">���������</td>
                  <td align="center">&nbsp;<%=AddUtil.ChangeDate2(cls.getCls_dt())%></td>
                  <td class=title style="font-size : 8pt;">�ð���ü</td>
                  <td class=title style="font-size : 8pt;">�ð�����</td>
                  <td class=title style="font-size : 8pt;">�ð���ü</td>
                  <td class=title style="font-size : 8pt;">�ð�����</td>
                  <td class=title style="font-size : 8pt;">����</td>
                  <td class=title style="font-size : 8pt;">������ȣ</td>
                  <td class=title style="font-size : 8pt;">������</td>
                  <td class=title style="font-size : 8pt;">������</td>
                </tr>
                <tr>
                  <td class=title style="font-size : 8pt;">LPG����</td>
                  <td align="center"><%String lpg_yn = car.getLpg_yn();%><%if(lpg_yn.equals("Y")){%>����<%}else if(lpg_yn.equals("N")){%>������<%}%></td>
                  <td align="center"><%=cha1.getCha_nm()%><%if(cha1.getCha_nm().equals("")){%><%=cha1.getCha_item()%><%}%></td>
                  <td align="center"><%=AddUtil.ChangeDate2(cha1.getCha_st_dt())%></td>
                  <td align="center"><%=cha2.getCha_nm()%><%if(cha2.getCha_nm().equals("")){%><%=cha2.getCha_item()%><%}%></td>
                  <td align="center"><%=AddUtil.ChangeDate2(cha2.getCha_st_dt())%></td>
                  <td align="center"><%=taecha.getCar_nm()%></td>
                  <td align="center"><%=taecha.getCar_no()%></td>
                  <td align="center"><%=AddUtil.ChangeDate2(taecha.getCar_rent_st())%></td>
                  <td align="center"><%=AddUtil.ChangeDate2(taecha.getCar_rent_et())%></td>
                </tr>
                <tr>
                  <td colspan="5" class=title style="font-size : 8pt;">�������</td>
                  <td colspan="5" class=title style="font-size : 8pt;">�����</td>
                </tr>
                <tr>
                  <td class=title style="font-size : 8pt;">ȸ���</td>
                  <td class=title style="font-size : 8pt;">������</td>
                  <td class=title style="font-size : 8pt;">����</td>
                  <td class=title style="font-size : 8pt;">����ó</td>
                  <td class=title style="font-size : 8pt;">�޴���</td>
                  <td class=title style="font-size : 8pt;">ȸ���</td>
                  <td class=title style="font-size : 8pt;">������</td>
                  <td class=title style="font-size : 8pt;">����ȣ</td>
                  <td class=title style="font-size : 8pt;">��ȭ/FAX</td>
                  <td class=title style="font-size : 8pt;">�����</td>
                </tr>
                <tr align="center">
                  <td><%=mgr_bus.get("COM_NM")==null?"":mgr_bus.get("COM_NM")%></td>
                  <td><%=mgr_bus.get("CAR_OFF_NM")==null?"":mgr_bus.get("CAR_OFF_NM")%></td>
                  <td><%=mgr_bus.get("NM")==null?"":mgr_bus.get("NM")%></td>
                  <td><%=mgr_bus.get("O_TEL")==null?"":mgr_bus.get("O_TEL")%></td>
                  <td><%=mgr_bus.get("TEL")==null?"":mgr_bus.get("TEL")%></td>
                  <td><%=mgr_dlv.get("COM_NM")==null?"":mgr_dlv.get("COM_NM")%></td>
                  <td><%=mgr_dlv.get("CAR_OFF_NM")==null?"":mgr_dlv.get("CAR_OFF_NM")%></td>
                  <td><%=pur.getRpt_no()%></td>
                  <td><%=mgr_dlv.get("O_TEL")==null?"":mgr_dlv.get("O_TEL")%></td>
                  <td><%=mgr_dlv.get("NM")==null?"":mgr_dlv.get("NM")%></td>
              </tr>
                <tr>
                  <td colspan="2" class=title style="font-size : 8pt;">����ں���/�ߵ���������</td>
                  <td colspan="8">&nbsp;<%if(!cls.getCls_st().equals("")){%>[<%=cls.getCls_st()%>]&nbsp;<%=HtmlUtil.htmlBR(cls.getCls_cau())%><%}%></td>
                </tr>
                <tr>
                  <td colspan="2" class=title style="font-size : 8pt;">Ư�����</td>
                  <td colspan="8">&nbsp;</td>
                </tr>
          </table>
	    </td>
    </tr>
    <tr>
        <td style='height:20' align="right"></td>
    </tr>    
    <tr>
        <td align='right'><span class="c"><a href="javascript:window.close()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a></span></td>
    </tr>
</table>	
</body>
</html>
