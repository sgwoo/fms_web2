<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.car_register.*, acar.car_office.*, acar.user_mng.*, acar.estimate_mng.*, acar.secondhand.*, acar.res_search.*"%>
<jsp:useBean id="a_db"      class="acar.cont.AddContDatabase"          scope="page"/>
<jsp:useBean id="al_db"     class="acar.client.AddClientDatabase"      scope="page"/>
<jsp:useBean id="cr_bean"   class="acar.car_register.CarRegBean"       scope="page"/>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="ai_db" scope="page" class="acar.con_ins.AddInsurDatabase"/>
<jsp:useBean id="ins" class="acar.con_ins.InsurBean" scope="page"/>

<%@ include file="/acar/cookies_doc.jsp" %>


<%
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st	 	= request.getParameter("rent_st")==null?"1":request.getParameter("rent_st");
	 
	CommonDataBase c_db 	= CommonDataBase.getInstance();
	AddCarMstDatabase cmb 	= AddCarMstDatabase.getInstance();
	CarRegDatabase crd 	= CarRegDatabase.getInstance();
	MaMenuDatabase nm_db 	= MaMenuDatabase.getInstance();
	CarOfficeDatabase cod 	= CarOfficeDatabase.getInstance();
	UserMngDatabase umd 	= UserMngDatabase.getInstance();		
	EstiDatabase e_db 	= EstiDatabase.getInstance();

	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//����Ÿ����
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//�����⺻����
	ContCarBean car = a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//�ڵ����⺻����
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//�����������
	cr_bean = crd.getCarRegBean(base.getCar_mng_id());

	//��������
	Hashtable reserv = rs_db.getCarInfo(base.getCar_mng_id());
		
	//�����뿩����
	ContFeeBean f_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	//�ش�뿩����
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, rent_st);
	
	//�ڵ���ü����
	ContCmsBean cms = a_db.getCmsMng(rent_mng_id, rent_l_cd);
	
	//��������
	//���ຸ������
	ContGiInsBean gins = a_db.getContGiInsNew(rent_mng_id, rent_l_cd, "1");
	int gin_size 	= a_db.getGinCnt(rent_mng_id, rent_l_cd);
	if(gin_size==0) gin_size = 1;
	ContGiInsBean ext_gin = new ContGiInsBean();
	for(int f=1; f<=gin_size ; f++){
		ext_gin = a_db.getContGiInsNew(rent_mng_id, rent_l_cd, Integer.toString(f));	
	}				
	
	//�������Կɼ�
	int fee_opt_amt = 0;
	if(rent_st.equals("2")){
		fee_opt_amt = f_fee.getOpt_s_amt()+f_fee.getOpt_v_amt();
	}else if(AddUtil.parseInt(rent_st) >2){
		ContFeeBean a_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, String.valueOf(AddUtil.parseInt(rent_st)-1));	
		fee_opt_amt = a_fee.getOpt_s_amt()+a_fee.getOpt_v_amt();
	}
	
	//�����⺻����
	ContCarBean f_fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1");

	//�����⺻����
	ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, rent_st);
	
	//����Ʈ����
	ContFeeRmBean f_fee_rm = a_db.getContFeeRm(rent_mng_id, rent_l_cd, "1");

	//����Ʈ����
	ContFeeRmBean fee_rm = a_db.getContFeeRm(rent_mng_id, rent_l_cd, rent_st);
				
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//��������
	ClientSiteBean site = al_db.getClientSite(base.getClient_id(), base.getR_site());
	
	//���ΰ�����������
	Vector car_mgrs = a_db.getCarMgrListNew(rent_mng_id, rent_l_cd, "Y");
	int mgr_size = car_mgrs.size();
	
	CarMgrBean mgr1 = new CarMgrBean();
	CarMgrBean mgr2 = new CarMgrBean();
	CarMgrBean mgr3 = new CarMgrBean();
	
	for(int i = 0 ; i < mgr_size ; i++){
        	CarMgrBean mgr = (CarMgrBean)car_mgrs.elementAt(i);
        	if(mgr.getMgr_st().equals("�����̿���")){
        		mgr1 = mgr;
        	}
        	if(mgr.getMgr_st().equals("�߰�������")){
        		mgr2 = mgr;
        	}
        	if(mgr.getMgr_st().equals("�븮��")){
        		mgr3 = mgr;
        	}
	}        					
	
	//��������
	String ins_st = ai_db.getInsSt(base.getCar_mng_id());
	ins = ai_db.getIns(base.getCar_mng_id(), ins_st);
		
    	//����ڵ�
    	UsersBean user_bean1 	= umd.getUsersBean(base.getBus_id());
    	UsersBean user_bean2 	= umd.getUsersBean(base.getMng_id());

	if(!rent_st.equals("1"))	user_bean1 	= umd.getUsersBean(fee.getExt_agnt());

    	
    	UsersBean user_bean3 	= new UsersBean();
    	
    	if(user_bean1.getBr_id().equals("S1") || user_bean1.getBr_id().equals("S2") || user_bean1.getBr_id().equals("I1") || user_bean1.getBr_id().equals("K3")||user_bean1.getBr_id().equals("S3") || user_bean1.getBr_id().equals("S4")||user_bean1.getBr_id().equals("S5") || user_bean1.getBr_id().equals("S6"))	user_bean3 	= umd.getUsersBean(nm_db.getWorkAuthUser("�������Ʈ���"));
    	if(user_bean1.getBr_id().equals("B1") || user_bean1.getBr_id().equals("G1") || user_bean1.getBr_id().equals("U1"))						user_bean3 	= umd.getUsersBean("000053");
    	if(user_bean1.getBr_id().equals("D1") || user_bean1.getBr_id().equals("J1"))											user_bean3 	= umd.getUsersBean(base.getBus_id2());
    	
	user_bean3 	= umd.getUsersBean(base.getBus_id2());
	
	//��������
	EstimateBean e_bean = new EstimateBean();
	
	e_bean = e_db.getEstimateShCase(f_fee_rm.getEst_id());
	
	
	String end_dt7 = c_db.addDay(fee.getRent_end_dt(), -7); //7����
	String end_dt5 = c_db.addDay(fee.getRent_end_dt(), -5); //5����
	
	//20120830 ����ƮȨ������ ����	
	
	
	
	String per = "0";
	
		
	if(!f_fee_rm.getAmt_per().equals(""))	per = f_fee_rm.getAmt_per();
	
	
	//���뿩���� ������
	Hashtable day_pers = shDb.getEstiRmDayPers(per);
	
	int day_per[] = new int[30];

	//�������� ī��Ʈ
	int day_cnt = 0;


	for (int j = 0 ; j < 30 ; j++){
		day_per[j] = AddUtil.parseInt((String)day_pers.get("PER_"+(j+1)));
		
		
		if(j+1 == 30){
			if(day_per[j]>100) 	day_per[j] = 0;
		}else{
			if(day_per[j]>99) 	day_per[j] = 0;
		}

		if(day_per[j]>0) 	day_cnt++;	
	}
	
%>


<!DOCTYPE HTML PUBLIC -//W3C//DTD HTML 4.01 Transitional//EN
http://www.w3.org/TR/html4/loose.dtd>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" charset="euc-kr">
<title>�ڵ����뿩�̿��༭</title>
<script src="http://code.jquery.com/jquery-1.11.3.min.js"></script>
</head>
<style type="text/css">

<!--
table {
 border-collapse: collapse;
 border-spacing: 0;
}

.table_rmcar   {border:1px solid #949494; margin-bottom:2px; font-size:13px;}
.table_rmcar td{border:1px solid #949494; height:24px;}
.table_n td{border:0px;}

.style1 {
	font-size:28px;
	font-weight:bold;
}
.style2 {
	font-size:13px;
	font-weight:bold;}
.style3{
	font-size:11px;}
.style4{
	font-size:12px;}
.style5{
	text-decoration:underline; color:#949494;
	}
.style6{
	font-size:12px;font-weight:bold;}
.style7{
	font-size:15px; font-weight:bold;}
.style8{
	font-size:10px;
}
	
@media print {
   h1{page-break-before:always; }

}
-->
</style>
<link href="/acar/main_car_hp/style_est.css" rel="stylesheet" type="text/css">
<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">
</object>
<body  onLoad="javascript:onprint();"> 
<div id="Layer1" style="position:absolute; left:235px; top:1840px; width:54px; height:41px; z-index:1"><img src="http://fms1.amazoncar.co.kr/acar/images/stamp.png" width="75" height="75"></div>

<div align="center">

<table width="680" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td><div align="center"><span class=style1>�� �� �� �� �� �� �� �� �� ��<%if(!rent_st.equals("1")){%> (����)<%}%></span></div></td>
	</tr>
	<tr>
		<td height=20></td>
	</tr>
  	<tr>
    	<td>
    		<table width="680" border="0" class="table_rmcar">
		      		<tr bgcolor="#FFFFFF" height="19">
			        	<td width="13%" bgcolor="e8e8e8"><div align="center">����ȣ</div></td>
			        	<td width="16%" ><div align="left">&nbsp;<%=rent_l_cd%></div></td>
			        	<td width="12%" bgcolor="e8e8e8"><div align="center">������</div></td>
			        	<td width="12%"><div align="left">&nbsp;<%=c_db.getNameById(base.getBrch_id(),"BRCH")%></div></td>
			        	<td width="16%" bgcolor="e8e8e8"><div align="center">���������</div></td>
			        	<td width="31%"><div align="left">&nbsp;<%=user_bean1.getUser_nm()%> <%=user_bean1.getUser_pos()%>
			        	    <%if(user_bean1.getLoan_st().equals("")){%><%=user_bean1.getHot_tel()%>
			        	    <%}else{%><%=user_bean1.getUser_m_tel()%><%}%>
			        	    </div></td>
			       	</tr>
				<tr bgcolor="#FFFFFF" height="35">
			        	<td bgcolor="e8e8e8"><div align="center">������</div></td>
			        	<td><div align="left">&nbsp;<%if(client.getClient_st().equals("1")){ 		out.println("����");
			        	}else if(client.getClient_st().equals("2")){  out.println("����");
			        	}else if(client.getClient_st().equals("3")){ 	out.println("���λ����(�Ϲݰ���)");
			        	}else if(client.getClient_st().equals("4")){	out.println("���λ����(���̰���)");
			        	}else if(client.getClient_st().equals("5")){ 	out.println("���λ����(�鼼�����)"); }%></div></td>
			        	<td bgcolor="e8e8e8"><div align="center">�뿩����</div></td>
			        	<td><div align="left">&nbsp;����Ʈ</div></td>
                    			
			        	<td bgcolor="e8e8e8"><div align="center">���������</div></td><!-- 2017. 10. 30 ���� ����� ���� -->
			        	<td><div align="left">&nbsp;<%=user_bean2.getUser_nm()%> <%=user_bean2.getUser_pos()%>
			        	    <%if(user_bean2.getUser_nm().equals("�輺��")){%>02-6263-6384
			        	    <%}else{%><%=user_bean2.getUser_m_tel()%><%}%>
			        	     <br>&nbsp;����, ��࿬��, �ݳ�, �뿩�����
			        	   </div></td>
			        	    <!--
			        	    	<td><div align="left">&nbsp�ڿ��� ���� 042-824-1770 			      
			        	     <br>&nbsp;����, ��࿬��, �ݳ�, �뿩�����
			        	    </div></td>
			        	    -->
			        	    
		      		</tr>
		      		
    			</table>
    		</td>
    	</tr>
<!--     	<tr> -->
<!--     		<td height=10></td> -->
<!--     	</tr> -->
    	<tr>
    		<td height=22px><div align="left"><img src=http://fms.amazoncar.co.kr/images/cardoc_arrow.gif> <span class=style2>������</span></td>
    	</tr>
    	<tr>
    		<td>
      			<table width="680" border="0"  class="table_rmcar">
			        <tr bgcolor="#FFFFFF" height="19">
			          	<td width="13%"><div align="center">����(��ǥ��)</div></td>
			          	<td width="34%" colspan="2"><div align="left">&nbsp;<%=client.getClient_nm()%><%if(client.getClient_st().equals("1") && !client.getClient_nm().equals(mgr1.getMgr_nm()) && !client.getClient_nm().equals(mgr2.getMgr_nm())){%>&nbsp;&nbsp;&nbsp;&nbsp;(������ �������� ���ܵ�)<%}%></div></td>
			          	<td width="18%"><div align="center"><%if(client.getClient_st().equals("1")){%>���ε�Ϲ�ȣ<%}else{%>�������<%}%></div></td>
			          	<td colspan="2"><div align="left">&nbsp;<%if(client.getClient_st().equals("1")){%><%=client.getSsn1()%>-<%=client.getSsn2()%><%}else{%><%=client.getSsn1()%><%}%></div></td>
			        </tr>
			        <tr bgcolor="#FFFFFF" height="19">
			          	<td><div align="center">��ȣ</div></td>
			         	 <td colspan="2"><div align="left">&nbsp;<%=client.getFirm_nm()%></div></td>
			          	<td><div align="center">����ڵ�Ϲ�ȣ</div></td>
			          	<td colspan="2"><div align="left">&nbsp;<%if(!client.getClient_st().equals("2")){%><%=client.getEnp_no1()%>-<%=client.getEnp_no2()%>-<%=client.getEnp_no3()%><%}%></div></td>
			        </tr>
			        <tr bgcolor="#FFFFFF" height="19">
			          	<td><div align="center">�ּ�</div></td>
			          	<td colspan="5"><div align="left">&nbsp;<%=client.getO_addr()%></div></td>
			        </tr>
			        <tr bgcolor="#FFFFFF" height="19">
			          	<td><div align="center">���������ȣ</div></td>
			          	<td colspan="2"><div align="left">&nbsp;<%if(!client.getClient_st().equals("1")){%><%=base.getLic_no()%><%}%></div></td>
			         	<td rowspan="2"><div align="center">����ó</div></td>
			          	<td width="9%"><div align="center">��ȭ��ȣ </div></td>
			          	<td width="26%"><div align="left">&nbsp;<%=AddUtil.phoneFormat(client.getO_tel())%></div></td>
			        </tr>
			        <tr bgcolor="#FFFFFF" height="19">
			          	<td><div align="center">���</div></td>
			          	<td colspan="2"><div align="left">&nbsp;
			          		<!--
			          		          <%if(mgr1.getLic_st().equals("1")){%>2������<%}%>
	                        		<%if(mgr1.getLic_st().equals("2")){%>1������<%}%>
	                        		<%if(mgr1.getLic_st().equals("3")){%>1������<%}%>
	                  -->      		
	                        	</td>
			          	<td><div align="center">�޴���</div></td>
			          	<td><div align="left">&nbsp;<%=AddUtil.phoneFormat(client.getM_tel())%></div></td>
			        </tr>
		    	</table>
			</td>
		</tr>
		<tr>
			<td height=2></td>
		</tr>
		<tr>
			<td>	
				<table width="680" border="0" class="table_rmcar">
			        <tr bgcolor="#FFFFFF" height="20">
			          	<td width="86" rowspan="4"><div align="center"><%if(!client.getClient_st().equals("1")){%>�߰�������<%}else{%>������<%}%></div></td>
			          	<td width="64"><div align="center">����</div></td>
			         	<td width="161"><div align="left">&nbsp;<%if(!client.getClient_st().equals("1")){%><%=mgr2.getMgr_nm()%><%}else{%><%=mgr1.getMgr_nm()%><%}%></div></td>
			          	<td width="120"><div align="center">�������</div></td>
			          	<td width="235" colspan="2"><div align="left">&nbsp;<%if(!client.getClient_st().equals("1")){%><%=AddUtil.ChangeSsnBdt(mgr2.getSsn())%><%}else{%><%=AddUtil.ChangeSsnBdt(mgr1.getSsn())%><%}%></div></td>
			        </tr>
			        <tr bgcolor="#FFFFFF" height="20">
			          	<td><div align="center">�ּ�</div></td>
			         	<td colspan="4"><div align="left">&nbsp;<%if(!client.getClient_st().equals("1")){%><%=mgr2.getMgr_addr()%><%}else{%><%=mgr1.getMgr_addr()%><%}%></div></td>
			        </tr>
			        <tr bgcolor="#FFFFFF" height="19">
			          	<td><div align="center">��ȭ��ȣ</div></td>
			          	<td><div align="left">&nbsp;<%if(!client.getClient_st().equals("1")){%><%=AddUtil.phoneFormat(mgr2.getMgr_m_tel())%><%if(mgr2.getMgr_m_tel().equals("")){%><%=AddUtil.phoneFormat(mgr2.getMgr_tel())%><%}%><%}else{%><%=AddUtil.phoneFormat(mgr1.getMgr_m_tel())%><%if(mgr1.getMgr_m_tel().equals("")){%><%=AddUtil.phoneFormat(mgr1.getMgr_tel())%><%}%><%}%></div></td>
			          	<td><div align="center">���������ȣ</div></td>
			          	<td colspan="2"><div align="left">&nbsp;<%if(!client.getClient_st().equals("1")){%><%=mgr2.getLic_no()%><%}else{%><%=mgr1.getLic_no()%><%}%></div></td>
			        </tr>
			        <tr bgcolor="#FFFFFF" height="19">
			          	<td><div align="center"><%if(!client.getClient_st().equals("1")){%>��Ÿ<%}else{%>�߰�������<%}%></div></td>
			          	<td colspan="4" ><div align="left">&nbsp;<%if(!client.getClient_st().equals("1")){%><%=mgr2.getEtc()%><%}else{%>
			          		<%=mgr2.getMgr_nm()%> <%=AddUtil.phoneFormat(mgr2.getMgr_m_tel())%> <%=mgr2.getLic_no()%>
			          		<%}%>
			          		</div></td>
			        </tr>
      			</table>
      		</td>
		</tr>
<!-- 		<tr> -->
<!-- 	    	<td height=10></td> -->
<!-- 	    </tr> -->
		<tr>
	    	<td height=22px><div align="left"><span class=style2><img src=http://fms.amazoncar.co.kr/images/cardoc_arrow.gif> �뿩���� �� �̿�Ⱓ</span></div></td>
	    </tr>
	    <tr>
			<td>
      		<table width="680" border="0" class="table_rmcar">
        		<tr bgcolor="e8e8e8" height="30">
		          	<td width="13%" ><div align="center">����</div></td>
		          	<td colspan="4"><div align="left">&nbsp;<%=reserv.get("CAR_NM")%>&nbsp;<%=reserv.get("CAR_NAME")%></div></td>
		          	<td width="13%"><div align="center">������ȣ</div></td>
		          	<td width="20%"><div align="left">&nbsp;<%=reserv.get("CAR_NO")%></div></td>
       		 	</tr>
        		<tr bgcolor="e8e8e8" height="19">
		          	<td><div align="center">��������</div></td>
		          	<td colspan="2"><div align="left">&nbsp;<%=reserv.get("FUEL_KD")%></div></td>
		          	<td width="13%"><div align="center">��������Ÿ�</div></td>
		          	<td width="20%"><div align="left">&nbsp;<%=AddUtil.parseDecimal(f_fee_etc.getSh_km())%>km</div></td>
		          	<td><div align="center">�߰��뿩ǰ��</div></td>
		          	<td><div align="left">&nbsp;<%if(f_fee_rm.getNavi_yn().equals("Y")){%>��ġ��������̼�<%}%></div></td>
        		</tr>
        		<tr bgcolor="e8e8e8" height="19">
		          	<td rowspan="3"><div align="center">�̿�Ⱓ</div></td>
		          	<td width="9%"><div align="center">�Ⱓ</div></td>
		          	<td colspan="2"><div align="left">&nbsp;<%=fee.getCon_mon()%>����
		          	<%if(!fee_etc.getCon_day().equals("0") && !fee_etc.getCon_day().equals("")){%><%=fee_etc.getCon_day()%>��<%}%>
		          	</div></td>
		          	<td><div align="center">�����̿�뵵</div></td>
		          	<td colspan="2"><div align="left">&nbsp;<%=f_fee_rm.getCar_use()%></div></td>
		        </tr>
		        <tr bgcolor="e8e8e8" height="19">
		          	<td><div align="center">��¥</div></td>
		          	<td colspan="5"><div align="left">&nbsp;
		          	<%if(fee.getRent_start_dt().equals("")){%>
		          	<%=AddUtil.ChangeDate2(fee_rm.getDeli_plan_dt())%>  ~ <%=AddUtil.ChangeDate2(fee_rm.getRet_plan_dt())%>
		          	<%}else{%>
		          	<%=AddUtil.ChangeDate2(fee.getRent_start_dt())%>  ~ <%=AddUtil.ChangeDate2(fee.getRent_end_dt())%>
		          	<%}%>
		          	</div></td>
		        </tr>
		        <tr bgcolor="e8e8e8" height="19">
		          	<td colspan="6"><div align="left">&nbsp;�뿩����� �������� �����ϸ�, 1���� �̸��� ���������Ͽ��� �� ��쿡�� 30���� 1������ ���ϴ�.</div></td>
		        </tr>
      		</table>
      	</td>
	</tr>
<!-- 	<tr> -->
<!--     	<td height=10></td> -->
<!--     </tr>		 -->
	<tr>
    	<td height=22px><div align="left"><span class=style2><img src=http://fms.amazoncar.co.kr/images/cardoc_arrow.gif> ����/���� ��������</span></div></td>
    </tr>
    <%	//�����϶� ��������
    		if(!rent_st.equals("1")){
    			fee_rm.setDeli_plan_dt("-");
    			fee_rm.setDeli_loc("-");
    			fee_rm.setRet_plan_dt(fee.getRent_end_dt());
    			fee_rm.setRet_loc(f_fee_rm.getRet_loc());
    		}
    		
    		String retPlanDt = fee_rm.getRet_plan_dt().substring(0,8);	// ������ YYYYMMDD
    		String retPlanDate = AddUtil.getDateDay(retPlanDt);	// ���� ����
    		String retPlanTime = "(���� 9��~���� 5��)";
    		if(retPlanDate.equals("��")){		// �Ͽ���
    			retPlanDt = String.valueOf(Integer.parseInt(retPlanDt) + 1);
    		} else if(retPlanDate.equals("��")){	// �����
    			retPlanTime = "(���� 9~12��)";
    		}
    %>
	<tr>
		<td>
      		<table width="680" border="0" class="table_rmcar">
		        <tr bgcolor="#FFFFFF" height="19">
		          	<td width="13%" rowspan="2" bgcolor="e8e8e8"><div align="center">��/�����ð�<br>�� ���</div></td>
		        	<td width="7%"><div align="center">����</div></td>
		          	<td width="25%"><div align="left">&nbsp;<%=AddUtil.getDate3(fee_rm.getDeli_plan_dt())%></div></td>
		          	<td width="7%"><div align="center">����</div></td>
<%-- 		        	<td width="45%"><div align="left">&nbsp;<%=AddUtil.getDate3(fee_rm.getRet_plan_dt())%></div></td> --%>
		        	<td width="45%">
		        		<div align="left">
		        			&nbsp;<span style="font-weight: bold;"><%=AddUtil.getDate3(retPlanDt)%> <%=retPlanTime%></span>
		        			<br>�� ��, ������ �� ������� ���� 9~12�ñ��� �ݳ� ����
		        			<br>�� ��, �Ͽ���, ����(����1��1��) �� �߼����� �ݳ��Ұ� (���Ϲݳ�)
		        		</div>
		        	</td>
		        </tr>
		        <tr bgcolor="#FFFFFF" height="19">
		          	<td><div align="center">���</div></td>
		          	<td><div align="left">&nbsp;<%=fee_rm.getDeli_loc()%></div></td>
		          	<td><div align="center">���</div></td>
		          	<td><div align="left">&nbsp;<%=fee_rm.getRet_loc()%>
		          	<%	//�����϶� ��������
    								if(!rent_st.equals("1")){
    									fee_rm.setDeli_loc(f_fee_rm.getDeli_loc());
    								}
    						%>	
		          	<%if(fee_rm.getDeli_loc().equals("����������")){%>
		          	(TEL.02-6263-6378)<br> &nbsp;���� �������� �������� 34�� 9
		          	<%}else if(fee_rm.getDeli_loc().equals("�������� ������")){%>		          	
		          	(TEL.042-824-1770)<br> &nbsp;���� ����� ���ɱ�100, ����ī��ũ
		          	<%}else if(fee_rm.getDeli_loc().equals("�λ����� ������")){%>
		          	(TEL.051-851-0606)<br> &nbsp;�λ� ������ ����õ�� 270���� 5, �ΰ��ڵ�������
		          	<%}else if(fee_rm.getDeli_loc().equals("�������� ������")){%>
		          	(TEL.062-385-0133)<br> &nbsp;���� ���� �󹫴����� 131-1, ��1���ڵ���������
		          	<%}else if(fee_rm.getDeli_loc().equals("�뱸���� ������")){%>
		          	(TEL.053-582-2998)<br> &nbsp;�뱸 �޼��� �޼���� 109�� 58, ��������������
		          	<%}%>
		          	</div></td>
		        </tr>
      		</table>
      	</td>
	</tr>
<!-- 	<tr> -->
<!--     	<td height=10></td> -->
<!--     </tr> -->
	<tr>
    	<td height=22px><div align="left"><span class=style2><img src=http://fms.amazoncar.co.kr/images/cardoc_arrow.gif> �뿩���</span></div></td>
    </tr>
	<tr>
		<td>
      		<table width="680" border="0" class="table_rmcar">
		        <tr>
		          	<td  width="13%" rowspan="2"  bgcolor="e8e8e8"><div align="center">����</div></td>
		          	<td colspan="4" bgcolor="e8e8e8" height="19"><div align="center">���뿩��</div></td>
		          	<td width="15%" rowspan="2" bgcolor="e8e8e8"><div align="center">��/������</div></td>
		          	<td width="15%" rowspan="2" bgcolor="e8e8e8"><div align="center">�հ�</div></td>
		        </tr>
		        <tr>
		          	<td height="21" width="14%" bgcolor="e8e8e8"><div align="center">����</div></td>
		          	<td width="14%" bgcolor="e8e8e8"><div align="center">������̼�</div></td>
		        	<td width="14%" bgcolor="e8e8e8"><div align="center">��Ÿ</div></td>
		          	<td width="14%" bgcolor="e8e8e8"><div align="center">�հ�</div></td>
		        </tr>
		        <tr>
		          	<td height="21" bgcolor="e8e8e8"><div align="center">���ް�</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(fee.getInv_s_amt()-fee_rm.getDc_s_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(fee_rm.getNavi_s_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(fee_rm.getEtc_s_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(fee.getFee_s_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(fee_rm.getCons1_s_amt()+fee_rm.getCons2_s_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(fee_rm.getT_fee_s_amt()+fee_rm.getCons1_s_amt()+fee_rm.getCons2_s_amt())%>&nbsp;</div></td>
		        </tr>
		        <tr>
		          	<td height="21" bgcolor="e8e8e8"><div align="center">�ΰ���</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(fee.getInv_v_amt()-fee_rm.getDc_v_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(fee_rm.getNavi_v_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(fee_rm.getEtc_v_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(fee.getFee_v_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(fee_rm.getCons1_v_amt()+fee_rm.getCons2_v_amt())%>&nbsp;</div></td>
		        	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(fee_rm.getT_fee_v_amt()+fee_rm.getCons1_v_amt()+fee_rm.getCons2_v_amt())%>&nbsp;</div></td>
		        </tr>
		        <tr>
		          	<td height="21" bgcolor="e8e8e8"><div align="center">�հ�</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(fee.getInv_s_amt()-fee_rm.getDc_s_amt()+fee.getInv_v_amt()-fee_rm.getDc_v_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(fee_rm.getNavi_s_amt()+fee_rm.getNavi_v_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(fee_rm.getEtc_s_amt()+fee_rm.getEtc_v_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(fee.getFee_s_amt()+fee.getFee_v_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(fee_rm.getCons1_s_amt()+fee_rm.getCons1_v_amt()+fee_rm.getCons2_s_amt()+fee_rm.getCons2_v_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(fee_rm.getT_fee_s_amt()+fee_rm.getT_fee_v_amt()+fee_rm.getCons1_s_amt()+fee_rm.getCons1_v_amt()+fee_rm.getCons2_s_amt()+fee_rm.getCons2_v_amt())%>&nbsp;</div></td>
		        </tr>
		        <tr>
		          	<td height="21" bgcolor="e8e8e8" ><div align="center">�������</div></td>
		          	<td colspan="6" bgcolor="e8e8e8" >
		          		<table width=100% border=0 cellspacing=0 cellpadding=0>
		          			<tr>
		          				<td style="border:0px;"><div align="left">&nbsp;<%if(fee_rm.getF_paid_way().equals("1")){%>1����ġ��<%}%> <%if(fee_rm.getF_paid_way().equals("2")){%>�뿩�� ���� <%}%>
		          	  			<%if(fee.getFee_sh().equals("1")){%>����<%}%><%if(fee.getFee_sh().equals("0")){%>�ĺ�<%}%>
		          	  			</div></td>
		          	  			<td style="border:0px;"> <div align="right">��/������� �����Դϴ�&nbsp;</div></td>
		          	  		</tr>
		          	  	</table>
		          	</td>
		        </tr>
		        <%if(rent_st.equals("1")){%>
		        <tr>
		        	<td height="21" bgcolor="e8e8e8"><div align="center">���ʰ����ݾ�</div></td>
		        	<td colspan="6" bgcolor="e8e8e8"><div align="left">&nbsp;<%=AddUtil.parseDecimal(fee_rm.getF_rent_tot_amt())%>��, 
		        	<%if(fee_rm.getF_paid_way().equals("1")){%>ùȸ�� �뿩��<%}%>
		        	<%if(fee_rm.getF_paid_way().equals("2")){%>�뿩�� �Ѿ�<%}%>
		        	<%if(fee_rm.getCons1_s_amt()>0){%>+ ��/������<%}%>
		        	</div></td>
		        </tr>
		        <%}%>
		        <tr>
		        	<td rowspan=2 bgcolor="e8e8e8"><div align="center">���</div></td>
		        	<td colspan="6" bgcolor="e8e8e8" height="50"><div align="left">&nbsp;<%=fee.getFee_cdt()%></div></td>
		        </tr>
		        <tr>
		          	<td colspan="7" bgcolor="e8e8e8" height="40"><div align="left">&nbsp;2ȸ�������� �뿩����� �ش� ȸ�� �뿩������ �Ϸ��� ���� �뿩��� �������� �˴ϴ�.</div></td>
		        </tr>

      		</table>
      	</td>
	</tr>
	<tr>
		<td height=2></td>
	</tr>
	<tr>
		<td>
			<table width="680" border="0" class="table_rmcar">
				<tr bgcolor="#FFFFFF">
          			<td width="13%" rowspan=2 bgcolor="e8e8e8"><div align="center">�ڵ���ü<br>��û</div></td>
          			<td height="42" align=center>�ڵ���ü<br>���</td>
          			<td height="40"><div align="center">
          				<table width="100%" border="0" cellpadding="0" cellspacing="1">
          					<tr>
          						<td style="border:0px;"><div align="center"><input type="checkbox" name="checkbox" value="checkbox" <%if(f_fee_rm.getCms_type().equals("card")){%>checked<%}%>> �ſ�ī�� �ڵ����</div></td>
          						<td style="border:0px;"><div align="center"><input type="checkbox" name="checkbox" value="checkbox" <%if(f_fee_rm.getCms_type().equals("cms")||fee_rm.getCms_type().equals("")){%>checked<%}%>> CMS �ڵ���ü</div></td>
          					</tr>
          					<tr>
          						<td style="border:0px;"><div align="center">(������ �ſ�ī�� �ڵ���� �̿��û�� �ۼ�)</div></td>
          						<td style="border:0px;"><div align="center">(���� CMS �����ü ��û�� �ۼ�)</div></td>
          					</tr>
          				</table>
          				</div></td>
        		</tr>
        		<tr bgcolor="#FFFFFF" height="40">
        			<td height="42" align=center>�ڵ���ü<br>���</td>
        			<td><div align="left"> &nbsp;2ȸ�������� �뿩���, ����뿩���, ��ü����, �ߵ����������, ��å��, ���·�, �ʰ�����뿩��</div></td>
        		</tr>
        	</table>
        </td>
    </tr>
	<tr>
    	<td height=5></td>
    </tr>
    <tr>
    	<td><div align="right">(����ȣ <%=rent_l_cd%> : Page 1/2)&nbsp;</div>
    </tr>
</table>

<h1 style="margin-top: 8px;">
<table width="680" border="0" cellspacing="0" cellpadding="0">
	<tr>
    	<td height=22px><div align="left"><span class=style2><img src=http://fms.amazoncar.co.kr/images/cardoc_arrow.gif> ������� �� ��å�ӻ���</span>&nbsp;
    	        (
    		<%if(ins.getIns_com_id().equals("0007")){%>		�Ｚȭ�� ������� 1588-5114, 
    		<%}else if(ins.getIns_com_id().equals("0008")){%>	����ȭ�� ������� 1588-0100, 
    		<%}else if(ins.getIns_com_id().equals("0038")){%>	����ī�������� ������� 1661-7977, 
    		<%}%>
    		����⵿ ����Ÿ�ڵ������� 1588-6688     		
    		)    		
    	    </div>
    	</td>
    </tr>
	<tr>
		<td>
      		<table width="680" border="0" class="table_rmcar">
        		<tr bgcolor="e8e8e8">
          			<td width="33%" style="padding: 0; height: 17px;"><div align="center"><span class=style4>�����ڿ���</span></div></td>
          			<td colspan="2" style="padding: 0; height: 17px;"><div align="center"><span class=style4>���谡�Գ���(�����ѵ�)</span></div></td>
          			<td colspan="2" style="padding: 0; height: 17px;"><div align="center"><span class=style4>�ڱ��������� ����</span></div></td>
        		</tr>
        		<tr bgcolor="#FFFFFF">
          			<td width="33%" rowspan="4" style="padding: 0;">
          				<table width="100%" border=0 cellspacing=0 cellpadding=0 class="table_n">
          					<tr>
          						<td><div align="center"><span class=style4>��26�� �̻�</span></div></td>
          					</tr>
          					<tr bgcolor="e8e8e8" style="border-top: 1px solid #949494; border-bottom: 1px solid #949494;">
          						<td style="height: 20;"><div align="center"><span class=style4>�����ڹ���</span></div></td>
          					</tr>
          					<tr>
          						<td>
          							<div align="left">
          								<span class=style4>
          									(1)�����<br>
          									(2)��༭�� ��õ� �߰�������<br>
          									�� ����ڰ� ���� �� ���λ������ ��쿡�� �������� ���� ����(������ �������� Ư�� ����. ��, ���� �� 9�ν������� Ư�� �̰���)
          								</span>
          							</div>
          						</td>
          					</tr>
          				</table>
          			</td>
          			<td width="10%" bgcolor="e8e8e8" height="30"><div align="center"><span class="style8">���ι��</span></div></td>
          			<td width="13%" bgcolor="e8e8e8"><div align="center"><span class="style8">����<br>(���ι��,��)</span></div></td>
          			<td width="32%" rowspan="4" valign=top>
          				<table width=100% border=0 cellspacing=0 cellpadding=0 class="table_n">
							<tr>
								<td style="height:3px;"></td>
							</tr>
          					<tr>
          						<td style="padding:7px;">&nbsp; <span class=style4>����1. �ڱ��������� ��å��(��� �Ǵ�)<br>
			          			&nbsp;&nbsp;&nbsp; <input type="checkbox" name="checkbox" value="checkbox" <%if(base.getCar_ja()==300000)%>checked<%%>> 30���� / <input type="checkbox" name="checkbox" value="checkbox" <%if(!String.valueOf(base.getCar_ja()).equals("300000"))%>checked<%%>> ��Ÿ(<%if(!String.valueOf(base.getCar_ja()).equals("300000") && base.getCar_ja()>=100000){%><%=base.getCar_ja()/10000%><%}else{%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%}%>)����</span><br>
			      				<span class=style3>(������ ��� �������ظ�å������ �ǰ� ����-������ ���պ��� ���Ժ���� ����� ����. ��,������� �߻��ÿ��� ����������ġ[=�������ݡ�(1-(���ɰ�������0.01))]�� 20% �ݾ��� ���� �δ���.)</span></td>
			      			</tr>
			      		</table>
			      	</td>
          			<td width="12%" rowspan="4" valign=top>
          				<table width=100% border=0 cellspacing=0 cellpadding=0 class="table_n">
          					<tr>
								<td style="height:10px;"></td>
							</tr>
          					<tr>
          						<td><div align="left">&nbsp; <span class=style3>����2.<br> &nbsp;&nbsp;�����Ⱓ ����<br>
          							&nbsp; �� ���������<br>&nbsp; <input type="checkbox" name="checkbox" value="checkbox" <%if(f_fee_rm.getMy_accid_yn().equals("Y")||f_fee_rm.getMy_accid_yn().equals("")){%>checked<%}%>> ���δ�<br>&nbsp; <input type="checkbox" name="checkbox" value="checkbox" <%if(f_fee_rm.getMy_accid_yn().equals("N")){%>checked<%}%>> ����</span></div></td>
          					</tr>
          				</table>
          			</td>
        		</tr>
        		<tr bgcolor="e8e8e8">
          			<td height="20"><div align="center"><span class="style8">�빰���</span></div></td>
          			<td><div align="center"><span class="style8">1���</span></div></td>
        		</tr>
        		<tr bgcolor="e8e8e8">
          			<td height="30"><div align="center"><span class="style8">�ڱ��ü���</span></div></td>
          			<td><div align="center"><span class="style8">���/���� 1���<br>�λ� 1500����</span></div></td>
        		</tr>
        		<tr bgcolor="e8e8e8">
         	 		<td height="22"><div align="center"><span class="style8">������������</span></div></td>
          			<td><div align="center"><span class="style8">2���</span></div></td>
        		</tr>
        		<tr bgcolor="#FFFFFF">
          			<td height="34" colspan="6" style="padding:5px;"><div align="left"><span style="font-size: 11px;">�� �������� : ���� ��å������ ���� ��� �߻���, �뿩������ �����Ⱓ�� �ش��ϴ� �뿩���(�Ƹ���ī �ܱⷻƮ ���ǥ ����)�� 50%�� ���� �δ��ϼž� �մϴ�. (�ڵ����뿩 ǥ�ؾ�� ��19���� ����)</span></div></td>
        		</tr>
      		</table>
      	</td>
	</tr>   
	<tr>
		<td height=2></td>
	</tr>
	<tr>
		<td>
      		<table width="680" border="0" class="table_rmcar">
		        <tr bgcolor="#FFFFFF" height="20">
		          	<td rowspan="3" width="13%"><div align="center">�Ƹ���ī<br>�ܱⷻƮ<br>���</div></td>
		          	<td><div align="center">�뿩����</div></td>
		          	<td colspan="4"><div align="center">�뿩�Ⱓ�� 1�� ��� (�ΰ��� ����)</div></td>
		        </tr>
		        <tr bgcolor="#FFFFFF" height="20">
		          	<td rowspan="2"><div align="center"><%=f_fee_rm.getCars()%></div></td>
		          	<td width="12%"><div align="center">1~2��</div></td>
		          	<td width="12%"><div align="center">3~4��</div></td>
		          	<td width="12%"><div align="center">5~6��</div></td>
		          	<td width="12%"><div align="center">7���̻�</div></td>
		        </tr>
		        <tr bgcolor="#FFFFFF" height="22">
		          	<td><div align="center"><%=AddUtil.parseDecimal(f_fee_rm.getAmt_01d()*1.1)%>��</div></td>
		          	<td><div align="center"><%=AddUtil.parseDecimal(f_fee_rm.getAmt_03d()*1.1)%>��</div></td>
		          	<td><div align="center"><%=AddUtil.parseDecimal(f_fee_rm.getAmt_05d()*1.1)%>��</div></td>
		          	<td><div align="center"><%=AddUtil.parseDecimal(f_fee_rm.getAmt_07d()*1.1)%>��</div></td>
		        </tr>
			</table>
		</td>
	</tr>
<!-- 	<tr> -->
<!--     	<td height=10></td> -->
<!--     </tr>	 -->
	<tr>
    	<td height=22px><div align="left"><span class=style2><img src=http://fms.amazoncar.co.kr/images/cardoc_arrow.gif> ��Ÿ�������</span></div></td>
    </tr>
	<tr>
		<td>
      		<table width="680" border="0" class="table_rmcar">
		        <tr bgcolor="#FFFFFF" height="35">
		          	<td bgcolor="e8e8e8"><div align="center">����<br>����Ÿ�</div></td>
		          	<td><div align="left">&nbsp;<%=AddUtil.parseDecimal(f_fee_etc.getAgree_dist())%>km / 1����, �ʰ��� 1km�� <%=AddUtil.parseDecimal(f_fee_etc.getOver_run_amt())%>��[�ΰ�������]�� �ʰ�����뿩�ᰡ �ΰ��˴ϴ�(�뿩�����)</div></td>
		        </tr>
		        <tr bgcolor="e8e8e8" height="35">
		          	<td><div align="center">������<br>����</div></td>
		          	<td bgcolor="e8e8e8"><div align="left">&nbsp;<span class=style6>�� ����� ����Ʈ(�����)�� Ư���� ������ ������ ���� �ʽ��ϴ�.<br>
		      			&nbsp;�̿��ڲ����� ������ �����Ͻþ� �̿��Ͻñ� �ٶ��ϴ�.</span></div></td>
		        </tr>
		        <tr bgcolor="#FFFFFF" height="65">
		          	<td bgcolor="e8e8e8">
		          		<div align="center" style="line-height: 20px;letter-spacing: -1px;">���·�<br>��������<br>���߻���</div>
		          	</td>
		          	<td><div align="left"><span class=style4>&nbsp;1) ������ �����Ⱓ �� �߻��Ǵ� ������ ���� �� ������� ���� ���·�� ��Ģ�� ���� ���� �δ��Ͽ��� �մϴ�.<br>
		      			&nbsp;2) ���� �̿� �� ����(�������, �������� ��ȯ ��)�� �ʿ��� ��� ���� �Ƹ���ī ��������ڿ��� �����Ͽ��� �ϸ�,<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		      			 ���� ����� �Ƹ���ī ���������ü�� ���� �湮�� �ּž� �մϴ�. ������ �Ƹ���ī���� �����ϸ�,<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ���κ������ ó���� ���ó���� �ȵ˴ϴ�.<br>
		      			&nbsp;3) ���� �̿� �� ��� �߻����� ��� ���� �Ƹ���ī ��������ڿ��� �����Ͽ��� �մϴ�.</span></div></td>
		        </tr>
		        <tr bgcolor="#FFFFFF" height="140">
		          	<td bgcolor="e8e8e8"><div align="center">��� ����</div></td>
		          	<td><div align="left"><span class=style6>&nbsp;1) �������� �������� ���������� ���Ⱓ ���� �ǻ縦 ǥ���ϰ� �Ƹ���ī�� ������ �� ����뿩�ᰡ <br>
		          		&nbsp;&nbsp;&nbsp;&nbsp; �����Ǹ� Ȯ���˴ϴ�.</span><br>
						&nbsp;<span class=style4>2) �������� ��࿬���� ����� ���</span> <span class=style2>��ุ�� 7����(<%=AddUtil.ChangeDate2(end_dt7)%>)����</span> <span class=style4>�Ƹ���ī�� ������ �ּž� �մϴ�.<br>
		      			&nbsp;3) ����뿩����� ����뿩������ �Ϸ����� �ſ�ī�� �ڵ���� �Ǵ� CMS �ڵ���ü�� �Ƹ���ī�� ����մϴ�.<br>
		      			&nbsp;&nbsp;&nbsp;&nbsp; ���� �뿩������ �Ϸ������� �뿩����� �������� ������ ��࿬���� �������� �ʽ��ϴ�.<br>
		      			&nbsp;4) ������ �������� �ؾ� ����Ⱓ ����� �߰� ���� ��û�� �����մϴ�.</span> <br>
		      			&nbsp;5) ���ڴ����� ������� ���� �뿩�� �������� ���Ұ���Ͽ� ����Ǹ�,����Ⱓ ����� �߰������� �Ұ����մϴ�.<br>
		      			&nbsp;<span class=style6>�� ��࿬�� ����� ���Բ��� ���� �Ƹ���ī�� �����ϼž� �ϸ�, ������ ������ ������ �������� <br>
		      			&nbsp;&nbsp;&nbsp;&nbsp; �ʴ� ������ �����մϴ�.(�Ƹ���ī ��࿬������ : <%=user_bean2.getUser_nm()%> <%=user_bean2.getUser_pos()%>
		      			    <%if(user_bean2.getUser_nm().equals("�輺��")){%>02-6263-6384
			        	    <%}else{%><%=user_bean2.getUser_m_tel()%><%}%>)</span></span></div></td><!-- 2017. 10. 30 ���� ����� ���� -->
		        </tr>
		        <tr bgcolor="e8e8e8" height="35">
		          	<td><div align="center">�뿩��<br>��ü��</div></td>
		          	<td bgcolor="e8e8e8"><div align="left"><span class=style4>&nbsp;1) �뿩�� ��ü�ÿ��� �Ӵ����� ��� ����� ������ �� ������, �� �� �������� ������ ��� �ݳ��Ͽ��� �մϴ�.<br>
 	      			&nbsp;2) �뿩�� ��ü�� �⸮ 24%�� ��ü���ڰ� �ΰ��˴ϴ�.</span></div></td>
		        </tr>
		        <tr bgcolor="e8e8e8" height="35">
		          	<td><div align="center">�ߵ�������</div></td>
		          	<td bgcolor="e8e8e8"><div align="left"><span class=style4>&nbsp;1) ���̿�Ⱓ�� <%if(day_cnt==30){%>1����<%}else{%><%=day_cnt%>��<%}%> �̻��� ��� : �ܿ��Ⱓ �뿩����� 10%�� ������� �ΰ��˴ϴ�.<br>
		      			&nbsp;2) ���̿�Ⱓ�� <%if(day_cnt==30){%>1����<%}else{%><%=day_cnt%>��<%}%> �̸��� ��� : �Ʒ� ��õ� ������� ����� �����ϴ�.</span></div></td>
		        </tr>
		        <tr bgcolor="#FFFFFF">
		          	<td height="35" bgcolor="e8e8e8"><div align="center">��Ÿ<br>Ư�̻���</div></td>
		          	<td><div align="left">&nbsp;<%=fee_etc.getCon_etc()%>
		          	<%if(AddUtil.parseInt(base.getRent_dt()) > 20160331 && client.getClient_st().equals("1") && AddUtil.parseInt(cm_bean.getS_st())>101 && AddUtil.parseInt(cm_bean.getS_st()) < 600 && AddUtil.parseInt(cm_bean.getS_st()) != 409){%>	
		          	�� ��༭�� �����ڷ� ����� ���(���� ������ ����)�� ���������մϴ�.
		          	<%}%>		          	
		          	</div></td>
		        </tr>
      		</table>
		</td>
	</tr>   
	<tr>
		<td><div align="left">&nbsp;<span class=style4>�� �� ��༭�� ������� ���� ������ "�ڵ��� �뿩 ǥ�ؾ��"�� ���մϴ�. (�Ƹ���ī ����Ʈ ���� Ȩ������ ����)</span></div></td>
<!-- 	<tr> -->
<!--     	<td height=10></td> -->
<!--     </tr> -->
	<tr>
    	<td height=22px><div align="left"><span class=style2><img src=http://fms.amazoncar.co.kr/images/cardoc_arrow.gif> ���̿�Ⱓ�� <%if(day_cnt==30){%>1����<%}else{%><%=day_cnt%>��<%}%> �̸��� ����� �������</span> <span class=style4>(�Ʒ� ���ؿ� �ǰ� �̿��� �� ��ŭ�� �뿩�ᰡ ����˴ϴ�.)
    	&nbsp;&nbsp;<span class=style3>�� ����:��, %</span></div></td>
    </tr>
	<tr>
		<td>
      		<table width="680" border="0" class="table_rmcar">
        		<tr bgcolor="#E8E8E8">
		          	<td width="107" height="22"><div align="center"><span class=style3>�̿��ϼ�</span></div></td>
		          	<td width="18"><div align="center"><span class=style3>1</span></div></td>
		          	<td width="18"><div align="center"><span class=style3>2</span></div></td>
		          	<td width="18"><div align="center"><span class=style3>3</span></div></td>
		          	<td width="18"><div align="center"><span class=style3>4</span></div></td>
		          	<td width="18"><div align="center"><span class=style3>5</span></div></td>
		          	<td width="18"><div align="center"><span class=style3>6</span></div></td>
		          	<td width="18"><div align="center"><span class=style3>7</span></div></td>
		          	<td width="18"><div align="center"><span class=style3>8</span></div></td>
		          	<td width="18"><div align="center"><span class=style3>9</span></div></td>
		          	<td width="18"><div align="center"><span class=style3>10</span></div></td>
		          	<td width="18"><div align="center"><span class=style3>11</span></div></td>
		          	<td width="18"><div align="center"><span class=style3>12</span></div></td>
		          	<td width="18"><div align="center"><span class=style3>13</span></div></td>
		          	<td width="18"><div align="center"><span class=style3>14</span></div></td>
		          	<td width="18"><div align="center"><span class=style3>15</span></div></td>
		          	<td width="18"><div align="center"><span class=style3>16</span></div></td>
		          	<td width="18"><div align="center"><span class=style3>17</span></div></td>
		          	<td width="18"><div align="center"><span class=style3>18</span></div></td>
		          	<td width="18"><div align="center"><span class=style3>19</span></div></td>
		          	<td width="18"><div align="center"><span class=style3>20</span></div></td>
		          	<td width="18"><div align="center"><span class=style3>21</span></div></td>
		          	<td width="18"><div align="center"><span class=style3>22</span></div></td>
		          	<td width="18"><div align="center"><span class=style3>23</span></div></td>
		          	<td width="18"><div align="center"><span class=style3>24</span></div></td>
		          	<td width="18"><div align="center"><span class=style3>25</span></div></td>
		          	<td width="18"><div align="center"><span class=style3>26</span></div></td>
		          	<td width="18"><div align="center"><span class=style3>27</span></div></td>
		          	<td width="18"><div align="center"><span class=style3>28</span></div></td>
		          	<td width="18"><div align="center"><span class=style3>29</span></div></td>
		          	<td width="19"><div align="center"><span class=style3>30</span></div></td>
        		</tr>
        		<tr bgcolor="#FFFFFF">
		          	<td height="24" bgcolor="e8e8e8"><div align="center"><span class=style3>���뿩��<br>���������</span></div></td>
		          	<%for (int j = 0 ; j < 30 ; j++){%>
		                <td bgcolor=#ffffff align=center><span class=style4><%if(day_per[j]>0){%><%=day_per[j]%><%}%></span></td>
		                <%}%>
        		</tr>
     		</table>
     	</td>
	</tr>
<!-- 	<tr> -->
<!-- 		<td height=10></td> -->
<!-- 	</tr>		 -->
	<tr>
		<td>
			<table width="680" border="0" class="table_rmcar">
				<tr>
					<td height=24 bgcolor="#FFFFFF" colspan=4><div align="center"><span class=style6>����� &nbsp;&nbsp;: &nbsp;&nbsp;<%=AddUtil.getDate3(fee.getRent_dt())%></span></div></td>
				</tr>
		        <tr bgcolor="#FFFFFF">
		          	<td width="46%" height=90><div align="left">&nbsp;&nbsp;<span class=style6>�뿩������ (�Ӵ���)</span><br>&nbsp;&nbsp;<span class=style4>����� �������� �ǻ���� 8, 802ȣ(���ǵ���, �������)</span><br><br>
		      			&nbsp;&nbsp;<span class=style4>(��)�Ƹ���ī ��ǥ�̻� &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;�� &nbsp;(��)</span></div></td>
		          	<td colspan="3"><div align="left">&nbsp;&nbsp;&nbsp;<span class=style6>�뿩�̿��� (������)</span><br>
		      			&nbsp;&nbsp;&nbsp;<span class=style4>�� ����� ������ Ȯ���Ͽ� ����� ü���ϰ� ��༭ 1���� ���� ������.<br>
		      			&nbsp;&nbsp;&nbsp;�� �뿩�̿���</span><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class=style5>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		      			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;		      			
		      			<span style="color:#000000;">(��)</span></span></div></td>
		        </tr>
		        
		        
		        <tr bgcolor="#FFFFFF">
		          	<td rowspan="3" style="padding:5px;"><div align="left"><span class=style3>�� �븮���� �� "�ڵ����뿩�̿���"�� ���Ͽ� �� ������ ����
		          	�ϰ� �������� �븮�Ͽ� (��)�Ƹ���ī�� �� ����� ü���մϴ�.
				</span></div></td>
		          	<td width="9%" rowspan="3"><div align="center"><span class=style6>�븮��</span></div></td>
		          	<td width="13%"  height="22"><div align="center">�� ��</div></td>
		          	<td width="34%"><div align="left">&nbsp;<%if(client.getClient_st().equals("1")){%><%=mgr3.getEtc()%><%}%></div></td>
		        </tr>
		        <tr bgcolor="#FFFFFF">
		          	<td height="22"><div align="center">�������</div></td>
		          	<td><div align="left">&nbsp;<%if(client.getClient_st().equals("1")){%><%=mgr3.getSsn()%><%}%></div></td>
		        </tr>
		        <tr bgcolor="#FFFFFF">
		          	<td height="22"><div align="center">�� ��</div></td>
		          	<td><div align="right"><%if(client.getClient_st().equals("1")){%><%=mgr3.getMgr_nm()%><%}%>(��)&nbsp;</div></td>
		        </tr>

		        
     	 	</table>
		</td>
  	</tr>  	
    <tr>
    	<td height=5></td>
    </tr>   
    <tr>
    	<td>
    		<table width=680 border=0 cellspacing=0 cellpadding=0>
    			<tr>
    				<td align=left>&nbsp;�ؾƸ���ī ����:�������� 140-004-023871 (��)�Ƹ���ī</td>
    				<td align=right>(����ȣ <%=rent_l_cd%> : Page 2/2)&nbsp;</td>
    			</tr>
    		</table>
    	</td>
    </tr>  	
</table>
</h1>
</div>

</body>
</html>

<script>
function onprint(){

factory.printing.header = ""; //��������� �μ�
factory.printing.footer = ""; //�������ϴ� �μ�
factory.printing.portrait = true; //true-�����μ�, false-�����μ�    
factory.printing.leftMargin = 9.0; //��������   
factory.printing.topMargin = 10.0; //��ܿ���    
factory.printing.rightMargin = 9.0; //��������
factory.printing.bottomMargin = 8.0; //�ϴܿ���
factory.printing.Print(true, window);//arg1-��ȭ����ǥ�ÿ���(true or false), arg2-��ü������orƯ��������
}
</script>