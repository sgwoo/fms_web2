<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.res_search.*, acar.estimate_mng.*, acar.secondhand.*, acar.user_mng.*" %>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>



<%
	CommonDataBase 		c_db = CommonDataBase.getInstance();
	EstiDatabase 		e_db 	= EstiDatabase.getInstance();
	UserMngDatabase 	umd 	= UserMngDatabase.getInstance();
	
	
	String rent_s_cd 	= request.getParameter("rent_s_cd")==null?"":request.getParameter("rent_s_cd");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String s_cd 		= request.getParameter("s_cd")==null?"":request.getParameter("s_cd");
	String c_id 		= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String cmd 		= request.getParameter("cmd")==null?"rent":request.getParameter("cmd");
	
	if(rent_s_cd.equals("") && !s_cd.equals("")){
		rent_s_cd 	= s_cd;
		car_mng_id 	= c_id;
	}

	
	//��������
	Hashtable reserv = rs_db.getCarInfo(car_mng_id);
	//�ܱ�������
	RentContBean rc_bean = rs_db.getRentContCase(rent_s_cd, car_mng_id);
	//������
	RentCustBean rc_bean2 = rs_db.getRentCustCase(rc_bean.getCust_st(), rc_bean.getCust_id(), rc_bean.getSite_id());
	//�ܱ������-���뺸����
	RentMgrBean rm_bean1 = rs_db.getRentMgrCase(rent_s_cd, "1");
	RentMgrBean rm_bean2 = rs_db.getRentMgrCase(rent_s_cd, "2");
	RentMgrBean rm_bean3 = rs_db.getRentMgrCase(rent_s_cd, "3");
	RentMgrBean rm_bean4 = rs_db.getRentMgrCase(rent_s_cd, "4");
	//�ܱ�뿩����
	RentFeeBean rf_bean = rs_db.getRentFeeCase(rent_s_cd);
	String rent_st = rc_bean.getRent_st();
	String use_st = rc_bean.getUse_st();
	//����������
	ScdRentBean sr_bean1 = rs_db.getScdRentCase(rent_s_cd, "1", "1");
	ScdRentBean sr_bean2 = rs_db.getScdRentCase(rent_s_cd, "2", "1");	
	//�Աݽ�����
	Vector conts = rs_db.getScdRentList(rent_s_cd, "fee");
	int cont_size = conts.size();
	int fee_rent_s_amt1 = 0;
	int fee_rent_v_amt1 = 0;
	int fee_rent_s_amt2 = 0;
	int fee_rent_v_amt2 = 0;	
	
	for(int i = 0 ; i < cont_size ; i++){
    		Hashtable sr = (Hashtable)conts.elementAt(i);
    		if(String.valueOf(sr.get("RENT_ST")).equals("1")){
    			fee_rent_s_amt1 = fee_rent_s_amt1 + AddUtil.parseInt(String.valueOf(sr.get("RENT_S_AMT")));
    			fee_rent_v_amt1 = fee_rent_v_amt1 + AddUtil.parseInt(String.valueOf(sr.get("RENT_V_AMT")));
    		}
    		if(String.valueOf(sr.get("RENT_ST")).equals("2")){
    			fee_rent_s_amt2 = fee_rent_s_amt2 + AddUtil.parseInt(String.valueOf(sr.get("RENT_S_AMT")));
    			fee_rent_v_amt2 = fee_rent_v_amt2 + AddUtil.parseInt(String.valueOf(sr.get("RENT_V_AMT")));
    		}    		
    	}	
    	if(fee_rent_s_amt1>0){
    		fee_rent_s_amt1 = fee_rent_s_amt1 + sr_bean1.getRent_s_amt();
    		fee_rent_v_amt1 = fee_rent_v_amt1 + sr_bean1.getRent_v_amt();
    		sr_bean1.setRent_s_amt(fee_rent_s_amt1);
    		sr_bean1.setRent_v_amt(fee_rent_v_amt1);
    	}
    	if(fee_rent_s_amt2>0){
    		fee_rent_s_amt2 = fee_rent_s_amt2 + sr_bean2.getRent_s_amt();
    		fee_rent_v_amt2 = fee_rent_v_amt2 + sr_bean2.getRent_v_amt();
    		sr_bean2.setRent_s_amt(fee_rent_s_amt2);
    		sr_bean2.setRent_v_amt(fee_rent_v_amt2);
    	}
    				
    	//����ڵ�
    	UsersBean user_bean1 	= umd.getUsersBean(rc_bean.getBus_id());
    	UsersBean user_bean2 	= umd.getUsersBean(rc_bean.getMng_id());
    	
    	UsersBean user_bean3 	= new UsersBean();
    	
    	if(user_bean1.getBr_id().equals("S1") || user_bean1.getBr_id().equals("S2"))	user_bean3 	= umd.getUsersBean("000085");
    	if(user_bean1.getBr_id().equals("B1") || user_bean1.getBr_id().equals("G1"))	user_bean3 	= umd.getUsersBean("000053");
    	if(user_bean1.getBr_id().equals("D1") || user_bean1.getBr_id().equals("J1"))	user_bean3 	= umd.getUsersBean("000052");
    	
	//�ڵ�����������
	String ins_com_id = shDb.getCarInsCom(car_mng_id);
	
	//��������
	EstimateBean e_bean = new EstimateBean();
	
	e_bean = e_db.getEstimateShCase(rf_bean.getEst_id());
	
	
	String end_dt7 = c_db.addDay(rc_bean.getRent_end_dt_d(), -7); //7����
	String end_dt5 = c_db.addDay(rc_bean.getRent_end_dt_d(), -5); //5����
	
	//20120830 ����ƮȨ������ ����	
	
	
	
	String per = "0";
	
		
	if(!rf_bean.getAmt_per().equals(""))	per = rf_bean.getAmt_per();
	
	
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


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>���� ����</title>
</head>
<style>
<!--
body {
	margin-left: 0px;
	margin-top: 0px;
	font-family: dotum,'����',gulim,'����',Helvetica,Apple-Gothic,sans-serif;
	font-size:0.8em;
	text-align:center;
	}
.style1 {
	font-size:2.15em;
	font-weight:bold;
}
.style2 {
	font-size:1.1em;
	font-weight:bold;}
.style3{
	font-size:0.8em;}
.style4{
	font-size:0.9em;}
.style5{
	text-decoration:underline;
	}
.style6{
	font-size:1.1em;}
-->
</style>
<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">
</object>
<body  onLoad="javascript:onprint();"> 
<div id="Layer1" style="position:absolute; left:250px; top:1950px; width:54px; height:41px; z-index:1"><img src="/acar/main_car_hp/images/stamp.png" width="75" height="75"></div>
<div align="center">
<table width="680" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td><div align="center"><span class=style1>�� �� �� �� �� �� �� �� �� ��</span></div></td>
	</tr>
	<tr>
		<td height=13></td>
	</tr>
  	<tr>
    		<td>
			<table width="680" border="0" cellpadding="2" cellspacing="1" bgcolor="#000000">
		      		<tr bgcolor="#FFFFFF" height="19">
			        	<td width="13%" bgcolor="e8e8e8"><div align="center">����ȣ</div></td>
			        	<td width="16%" ><div align="left">&nbsp;<%=rent_s_cd%></div></td>
			        	<td width="12%" bgcolor="e8e8e8"><div align="center">������</div></td>
			        	<td width="13%"><div align="left">&nbsp;<%=c_db.getNameById(rc_bean.getBrch_id(),"BRCH")%></div></td>
			        	<td width="15%" bgcolor="e8e8e8"><div align="center">���������</div></td>
			        	<td width="31%"><div align="left">&nbsp;<%=user_bean1.getUser_nm()%> <%=user_bean1.getUser_pos()%>
			        	    <%if(user_bean1.getUser_nm().equals("���¿�")){%>02-392-4242
			        	    <%}else{%><%=user_bean1.getUser_m_tel()%><%}%>
			        	    </div></td>
			       	</tr>
				<tr bgcolor="#FFFFFF">
			        	<td bgcolor="e8e8e8" rowspan="2"><div align="center">������</div></td>
			        	<td rowspan="2"><div align="left">&nbsp;<%=rc_bean2.getCust_st()%></div></td>
			        	<td rowspan="2" bgcolor="e8e8e8"><div align="center">�뿩����</div></td>
			        	<td rowspan="2"><div align="left"><%if(rent_st.equals("1")){%>
                �ܱ�뿩 
                <%}else if(rent_st.equals("2")){%>
                ������� 
                <%}else if(rent_st.equals("3")){%>
                ������ 
                <%}else if(rent_st.equals("9")){%>
                ������� 
                <%}else if(rent_st.equals("10")){%>
                �������� 
                <%}else if(rent_st.equals("4")){%>
                �����뿩 
                <%}else if(rent_st.equals("5")){%>
                �������� 
                <%}else if(rent_st.equals("6")){%>
                �������� 
                <%}else if(rent_st.equals("7")){%>
                �������� 
                <%}else if(rent_st.equals("8")){%>
                ������ 
                <%}else if(rent_st.equals("11")){%>
                �����
                <%}else if(rent_st.equals("12")){%>
                ����Ʈ
                <%}%>	
                    				</div>
                    			</td>
                    			
			        	    <td bgcolor="e8e8e8"><div align="center">���������</div></td>
			        		<td><div align="left">&nbsp;<%=user_bean3.getUser_nm()%> <%=user_bean3.getUser_pos()%> 
			        	    <%if(user_bean3.getUser_nm().equals("���¿�")){%>02-392-4242
			        	    <%}else{%><%=user_bean3.getUser_m_tel()%><%}%>
			        	     <br>&nbsp;����, ��࿬��, �ݳ�, �뿩�����
			        	    </div></td>
		      		</tr>
		      		<tr bgcolor="#FFFFFF" height="19">
                    			<td bgcolor="e8e8e8"><div align="center">���ó�������</div></td>
			        	<td><div align="left">&nbsp;<%=user_bean2.getUser_nm()%> <%=user_bean2.getUser_pos()%>
			        	    <%if(user_bean2.getUser_nm().equals("���¿�")){%>02-392-4242
			        	    <%}else{%><%=user_bean2.getUser_m_tel()%><%}%>
			        	   </div></td>
				</tr>
    			</table>
    		</td>
    	</tr>
    	<tr>
    		<td height=10></td>
    	</tr>
    	<tr>
    		<td><div align="left"><img src=/images/cardoc_arrow.gif> <span class=style2>������</span></td>
    	</tr>
    	<tr>
    		<td>
      			<table width="680" border="0" cellpadding="3" cellspacing="1" bgcolor="#000000">
			        <tr bgcolor="#FFFFFF" height="18">
			          	<td width="13%"><div align="center">����(��ǥ��)</div></td>
			          	<td width="34%" colspan="2"><div align="left">&nbsp;<%=rc_bean2.getCust_nm()%></div></td>
			          	<td width="18%"><div align="center">�ֹ�(����)��Ϲ�ȣ</div></td>
			          	<td colspan="2"><div align="left">&nbsp;<%=rc_bean2.getSsn()%></div></td>
			        </tr>
			        <tr bgcolor="#FFFFFF" height="18">
			          	<td><div align="center">��ȣ</div></td>
			         	 <td colspan="2"><div align="left">&nbsp;<%=rc_bean2.getFirm_nm()%></div></td>
			          	<td><div align="center">����ڵ�Ϲ�ȣ</div></td>
			          	<td colspan="2"><div align="left">&nbsp;<%=rc_bean2.getEnp_no()%></div></td>
			        </tr>
			        <tr bgcolor="#FFFFFF" height="18">
			          	<td><div align="center">�ּ�</div></td>
			          	<td colspan="5"><div align="left">&nbsp;<%=rc_bean2.getAddr()%></div></td>
			        </tr>
			        <tr bgcolor="#FFFFFF" height="18">
			          	<td><div align="center">���������ȣ</div></td>
			          	<td colspan="2"><div align="left">&nbsp;<%=rm_bean4.getLic_no()%></div></td>
			         	<td rowspan="2"><div align="center">����ó</div></td>
			          	<td width="9%"><div align="center">��ȭ��ȣ </div></td>
			          	<td width="26%"><div align="left">&nbsp;<%=rm_bean4.getTel()%></div></td>
			        </tr>
			        <tr bgcolor="#FFFFFF" height="18">
			          	<td><div align="center">��������</div></td>
			          	<td colspan="2"><div align="left">&nbsp;<%if(rm_bean4.getLic_st().equals("1")){%>2������<%}%>
	                        		<%if(rm_bean4.getLic_st().equals("2")){%>1������<%}%>
	                        		<%if(rm_bean4.getLic_st().equals("3")){%>1������<%}%>
	                        	</td>
			          	<td><div align="center">�޴���</div></td>
			          	<td><div align="left">&nbsp;<%=rm_bean4.getEtc()%></div></td>
			        </tr>
		    	</table>
			</td>
		</tr>
		<tr>
			<td height=2></td>
		</tr>
		<tr>
			<td>	
				<table width="680" border="0" cellpadding="3" cellspacing="1" bgcolor="#000000">
			        <tr bgcolor="#FFFFFF" height="18">
			          	<td width="85" rowspan="4"><div align="center">�߰�������</div></td>
			          	<td width="64"><div align="center">����</div></td>
			         	<td width="162"><div align="left">&nbsp;<%=rm_bean1.getMgr_nm()%></div></td>
			          	<td width="121"><div align="center">�ֹε�Ϲ�ȣ</div></td>
			          	<td width="242" colspan="2"><div align="left">&nbsp;<%=rm_bean1.getSsn()%></div></td>
			        </tr>
			        <tr bgcolor="#FFFFFF" height="18">
			          	<td><div align="center">�ּ�</div></td>
			         	<td colspan="4"><div align="left">&nbsp;<%=rm_bean1.getAddr()%></div></td>
			        </tr>
			        <tr bgcolor="#FFFFFF" height="18">
			          	<td><div align="center">��ȭ��ȣ</div></td>
			          	<td><div align="left">&nbsp;<%=rm_bean1.getTel()%></div></td>
			          	<td><div align="center">���������ȣ</div></td>
			          	<td colspan="2"><div align="left">&nbsp;<%=rm_bean1.getLic_no()%></div></td>
			        </tr>
			        <tr bgcolor="#FFFFFF" height="18">
			          	<td><div align="center">��Ÿ</div></td>
			          	<td colspan="4"  style="font-size:0.8em;"><div align="left">&nbsp;<%=rm_bean1.getEtc()%></div></td>
			        </tr>
      			</table>
      		</td>
		</tr>
		<tr>
	    	<td height=10></td>
	    </tr>
		<tr>
	    	<td><div align="left"><span class=style2><img src=/images/cardoc_arrow.gif> �뿩���� �� �̿�Ⱓ</span></div></td>
	    </tr>
	    <tr>
			<td>
      		<table width="680" border="0" cellpadding="3" cellspacing="1" bgcolor="#000000">
        		<tr bgcolor="e8e8e8" height="30">
		          	<td  height="30"width="13%" ><div align="center">����</div></td>
		          	<td colspan="4"><div align="left">&nbsp;<%=reserv.get("CAR_NM")%>&nbsp;<%=reserv.get("CAR_NAME")%></div></td>
		          	<td width="13%"><div align="center">������ȣ</div></td>
		          	<td width="20%"><div align="left">&nbsp;<%=reserv.get("CAR_NO")%></div></td>
       		 	</tr>
        		<tr bgcolor="e8e8e8" height="18">
		          	<td><div align="center">��������</div></td>
		          	<td colspan="2"><div align="left">&nbsp;<%=reserv.get("FUEL_KD")%></div></td>
		          	<td width="13%"><div align="center">��������Ÿ�</div></td>
		          	<td width="20%"><div align="left">&nbsp;<%=AddUtil.parseDecimal(rf_bean.getDist_km())%>km</div></td>
		          	<td><div align="center">�߰��뿩ǰ��</div></td>
		          	<td><div align="left">&nbsp;<%if(rf_bean.getNavi_yn().equals("Y")){%>��ġ��������̼�<%}%></div></td>
        		</tr>
        		<tr bgcolor="e8e8e8" height="18">
		          	<td rowspan="3"><div align="center">�̿�Ⱓ</div></td>
		          	<td width="9%"><div align="center">�Ⱓ</div></td>
		          	<td colspan="2"><div align="left">&nbsp;<%=rc_bean.getRent_months()%>����
		          	<%if(!rc_bean.getRent_days().equals("0")){%><%=rc_bean.getRent_days()%>��<%}%>
		          	</div></td>
		          	<td>�����̿�뵵</td>
		          	<td colspan="2"><div align="left">&nbsp;<%=rf_bean.getCar_use()%></div></td>
		        </tr>
		        <tr bgcolor="e8e8e8" height="18">
		          	<td><div align="center">��¥</div></td>
		          	<td colspan="5"><div align="left">&nbsp;<%=AddUtil.ChangeDate2(rc_bean.getRent_start_dt_d())%> <!--<%=rc_bean.getRent_start_dt_h()%>�� <%=rc_bean.getRent_start_dt_s()%>��--> ~ <%=AddUtil.ChangeDate2(rc_bean.getRent_end_dt_d())%> <!--<%=rc_bean.getRent_end_dt_h()%>�� <%=rc_bean.getRent_end_dt_s()%>��--></div></td>
		        </tr>
		        <tr bgcolor="e8e8e8" height="18">
		          	<td colspan="6"><div align="left">&nbsp;�뿩����� �������� �����ϸ�, 1���� �̸��� ���������Ͽ��� �� ��쿡�� 30���� 1������ ���ϴ�.</div></td>
		        </tr>
      		</table>
      	</td>
	</tr>
	<tr>
    	<td height=10></td>
    </tr>		
	<tr>
    	<td><div align="left"><span class=style2><img src=/images/cardoc_arrow.gif> ����/���� ��������</span></div></td>
    </tr>
	<tr>
		<td>
      		<table width="680" border="0" cellpadding="3" cellspacing="1" bgcolor="#000000">
		        <tr bgcolor="#FFFFFF" height="20">
		          	<td width="13%" rowspan="2" bgcolor="e8e8e8"><div align="center">��/�����ð�<br>�� ���</div></td>
		        	<td width="9%"><div align="center">����</div></td>
		          	<td><div align="left">&nbsp;<%if(rc_bean.getDeli_dt_d().equals("")){%><%=AddUtil.ChangeDate2(rc_bean.getDeli_plan_dt_d())%> <%=rc_bean.getDeli_plan_dt_h()%>��<%=rc_bean.getDeli_plan_dt_s()%>��<%}else{%><%=AddUtil.ChangeDate2(rc_bean.getDeli_dt_d())%> <%=rc_bean.getDeli_dt_h()%>��<%=rc_bean.getDeli_dt_s()%>��<%}%></div></td>
		          	<td width="9%"><div align="center">����</div></td>
		        	<td><div align="left">&nbsp;<%if(rc_bean.getRet_dt_d().equals("")){%><%=AddUtil.ChangeDate2(rc_bean.getRet_plan_dt_d())%> <%=rc_bean.getRet_plan_dt_h()%>��<%=rc_bean.getRet_plan_dt_s()%>��<%}else{%><%=AddUtil.ChangeDate2(rc_bean.getRet_dt_d())%> <%=rc_bean.getRet_dt_h()%>��<%=rc_bean.getRet_dt_s()%>��<%}%></div></td>
		        </tr>
		        <tr bgcolor="#FFFFFF" height="20">
		          	<td><div align="center">���</div></td>
		          	<td><div align="left">&nbsp;<%=rc_bean.getDeli_loc()%></div></td>
		          	<td><div align="center">���</div></td>
		          	<td><div align="left">&nbsp;<%=rc_bean.getRet_loc()%></div></td>
		        </tr>
      		</table>
      	</td>
	</tr>
	<tr>
    	<td height=10></td>
    </tr>
	<tr>
    	<td><div align="left"><span class=style2><img src=/images/cardoc_arrow.gif> �뿩���</span></div></td>
    </tr>
	<tr>
		<td>
      		<table width="680" border="0" cellpadding="0" cellspacing="1" bgcolor="#000000">
		        <tr>
		          	<td  width="13%" rowspan="2"  bgcolor="e8e8e8"><div align="center">����</div></td>
		          	<td colspan="4" bgcolor="e8e8e8" height="25"><div align="center">���뿩��</div></td>
		          	<td width="13%" bgcolor="e8e8e8"><div align="center">�뿩�� �Ѿ�</div></td>
		          	<td width="13%" rowspan="2" bgcolor="e8e8e8"><div align="center">��/������</div></td>
		          	<td width="13%" rowspan="2" bgcolor="e8e8e8"><div align="center">�հ�</div></td>
		        </tr>
		        <tr>
		          	<td height="25" width="12%" bgcolor="e8e8e8"><div align="center">����</div></td>
		          	<td width="12%" bgcolor="e8e8e8"><div align="center">������̼�</div></td>
		        	<td width="12%" bgcolor="e8e8e8"><div align="center">��Ÿ</div></td>
		          	<td width="12%" bgcolor="e8e8e8"><div align="center">�հ�</div></td>
		          	<td bgcolor="e8e8e8"><div align="center"><%=rc_bean.getRent_months()%>����
		          	<%if(!rc_bean.getRent_days().equals("0")){%><%=rc_bean.getRent_days()%>��<%}%></div></td>
		        </tr>
		        <tr>
		          	<td height="25" bgcolor="e8e8e8"><div align="center">���ް�</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(rf_bean.getInv_s_amt()-rf_bean.getDc_s_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(rf_bean.getNavi_s_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(rf_bean.getEtc_s_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(rf_bean.getInv_s_amt()-rf_bean.getDc_s_amt()+rf_bean.getNavi_s_amt()+rf_bean.getEtc_s_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(rf_bean.getFee_s_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(rf_bean.getCons1_s_amt()+rf_bean.getCons2_s_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(rf_bean.getFee_s_amt()+rf_bean.getCons1_s_amt()+rf_bean.getCons2_s_amt())%>&nbsp;</div></td>
		        </tr>
		        <tr>
		          	<td height="25" bgcolor="e8e8e8"><div align="center">�ΰ���</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(rf_bean.getInv_v_amt()-rf_bean.getDc_v_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(rf_bean.getNavi_v_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(rf_bean.getEtc_v_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(rf_bean.getInv_v_amt()-rf_bean.getDc_v_amt()+rf_bean.getNavi_v_amt()+rf_bean.getEtc_v_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(rf_bean.getFee_v_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(rf_bean.getCons1_v_amt()+rf_bean.getCons2_v_amt())%>&nbsp;</div></td>
		        	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(rf_bean.getFee_v_amt()+rf_bean.getCons1_v_amt()+rf_bean.getCons2_v_amt())%>&nbsp;</div></td>
		        </tr>
		        <tr>
		          	<td height="25" bgcolor="e8e8e8"><div align="center">�հ�</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(rf_bean.getInv_s_amt()-rf_bean.getDc_s_amt()+rf_bean.getInv_v_amt()-rf_bean.getDc_v_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(rf_bean.getNavi_s_amt()+rf_bean.getNavi_v_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(rf_bean.getEtc_s_amt()+rf_bean.getEtc_v_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(rf_bean.getInv_s_amt()+rf_bean.getInv_v_amt()-rf_bean.getDc_s_amt()-rf_bean.getDc_v_amt()+rf_bean.getNavi_s_amt()+rf_bean.getNavi_v_amt()+rf_bean.getEtc_s_amt()+rf_bean.getEtc_v_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(rf_bean.getFee_s_amt()+rf_bean.getFee_v_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(rf_bean.getCons1_s_amt()+rf_bean.getCons1_v_amt()+rf_bean.getCons2_s_amt()+rf_bean.getCons2_v_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(rf_bean.getFee_s_amt()+rf_bean.getFee_v_amt()+rf_bean.getCons1_s_amt()+rf_bean.getCons1_v_amt()+rf_bean.getCons2_s_amt()+rf_bean.getCons2_v_amt())%>&nbsp;</div></td>
		        </tr>
		        <tr>
		          	<td height="25" bgcolor="e8e8e8" ><div align="center">�������</div></td>
		          	<td colspan="7" bgcolor="e8e8e8" >
		          		<table width=100% border=0 cellspacing=0 cellpadding=0>
		          			<tr>
		          				<td><div align="left">&nbsp;<%if(rf_bean.getF_paid_way().equals("1")){%>1����ġ��<%}%> <%if(rf_bean.getF_paid_way().equals("2")){%>�뿩�� ���� <%}%>
		          	  			<%if(rf_bean.getPaid_way().equals("1")){%>����<%}%><%if(rf_bean.getPaid_way().equals("2")){%>�ĺ�<%}%>
		          	  			</div></td>
		          	  			<td> <div align="right">��/������� �����Դϴ�&nbsp;</div></td>
		          	  		</tr>
		          	  	</table>
		          	</td>
		        </tr>
		        <tr>
		        	<td height="25" bgcolor="e8e8e8"><div align="center">���ʰ����ݾ�</div></td>
		        	<td colspan="7" bgcolor="e8e8e8"><div align="left">&nbsp;<%=AddUtil.parseDecimal(rf_bean.getF_rent_tot_amt())%>��, 
		        	<%if(rf_bean.getF_paid_way().equals("1")){%>ùȸ�� �뿩��<%}%>
		        	<%if(rf_bean.getF_paid_way().equals("2")){%>�뿩�� �Ѿ�<%}%>
		        	
		        	<%if(rf_bean.getCons1_s_amt()>0){%>+ ��/������<%}%>
		        	<!--<%if(rf_bean.getF_paid_way2().equals("1")){%>+ ������<%}%>-->
		        	 
		        	&nbsp;
		        	<%if(sr_bean1.getRent_s_amt()+sr_bean2.getRent_s_amt()>0){%>
		        	(
		        	<%}%>
		        	<%if(sr_bean1.getRent_s_amt()>0){%>
		        	����� : <%=AddUtil.parseDecimal(sr_bean1.getRent_s_amt()+sr_bean1.getRent_v_amt())%>��
		        	<%}%>
		        	<%if(sr_bean1.getRent_s_amt()>0 && sr_bean2.getRent_s_amt()>0){%>
		        	/
		        	<%}%>		        	
		        	<%if(sr_bean2.getRent_s_amt()>0){%>
		        	<%if(sr_bean2.getPaid_st().equals("1")){%>����<%}%>
		        	<%if(sr_bean2.getPaid_st().equals("2")){%>�ſ�ī��<%}%>
		        	<%if(sr_bean2.getPaid_st().equals("3")){%>�ڵ���ü<%}%>
		        	<%if(sr_bean2.getPaid_st().equals("4")){%>�������Ա�<%}%>
		        	 : <%=AddUtil.parseDecimal(sr_bean2.getRent_s_amt()+sr_bean2.getRent_v_amt())%>��
		        	<%}%>		        	
		        	<%if(sr_bean1.getRent_s_amt()+sr_bean2.getRent_s_amt()>0){%>
		        	)
		        	<%}%>
		        	</div></td>
		        </tr>
		        <tr>
		        	<td rowspan=2 bgcolor="e8e8e8"><div align="center">���</div></td>
		        	<td colspan="7" bgcolor="e8e8e8" height="50"><div align="left">&nbsp;<%=rf_bean.getFee_etc()%></div></td>
		        </tr>
		        <tr>
		          	<td colspan="7" bgcolor="e8e8e8" height="40"><div align="left">&nbsp;��ȸ���뿩�� �� ��/�����Ḧ ������ �ݾ��� CMS�ڵ���ü�� �Ƹ���ī�� ����մϴ�.
		          	<br>&nbsp;2ȸ�������� �뿩����� �ش� ȸ�� �뿩������ �Ϸ��� ���� �뿩��� �������� �˴ϴ�.</div></td>
		        </tr>

      		</table>
      	</td>
	</tr>
	<tr>
		<td height=2></td>
	</tr>
	<tr>
		<td>
			<table width="680" border="0" cellpadding="0" cellspacing="1" bgcolor="#000000">
				<tr bgcolor="#FFFFFF">
          			<td width="13%" rowspan=2 bgcolor="e8e8e8"><div align="center">�ڵ���ü<br>��û</div></td>
          			<td width="13%" height="50"><div align="center">�ڵ���ü<br>�������¹�ȣ</div></td>
          			<td width="35%" style="line-height:20px;">     			
          			<%if(rf_bean.getCms_bank().equals("")){%>
          			<div align="center"><span class=style5>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><br>
          			(&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;����&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;����&nbsp;&nbsp;)</div>
          			<%}else{%>
          			<div align="center"><span class=style5>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=rf_bean.getCms_acc_no()%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><br>
          			(&nbsp;&nbsp;<%=rf_bean.getCms_bank()%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;����&nbsp;&nbsp;)</div>
          			<%}%>
          			</td>
          			<td width="13%"><div align="center">������<br>(�뿩�̿���)</div></td>
          			<td width="26%"><div align="right"><%=rf_bean.getCms_dep_nm()%>&nbsp;(��)&nbsp;</div></td>
        		</tr>
        		<tr bgcolor="#FFFFFF" height="40">
        			<td height="42">�ڵ���ü<br>���</td>
        			<td colspan="3"><div align="left"> &nbsp;2ȸ�������� �뿩���, ����뿩���, ��ü����, �ߵ����������, ��å��, ���·�</div></td>
        		</tr>
        	</table>
        </td>
    </tr>
	<tr>
    	<td height=5></td>
    </tr>
    <tr>
    	<td><div align="right">(����ȣ <%=rent_s_cd%> : Page 1/2)&nbsp;</div>
    </tr>
	<tr>
    	<td height=5></td>
    </tr>
	<tr>
    	<td><div align="left"><span class=style2><img src=/images/cardoc_arrow.gif> ������� �� ��å�ӻ���</span>&nbsp;
    	        (
    		<%if(ins_com_id.equals("0007")){%>		�Ｚȭ�� ������� 1588-5114, 
    		<%}else if(ins_com_id.equals("0008")){%>	����ȭ�� ������� 1588-0100, 
    		<%}%>
    		����⵿ ����Ÿ�ڵ������� 1588-6688 
    		)    		
    	    </div>
    	</td>
    </tr>
	<tr>
		<td>
      		<table width="680" border="0" cellpadding="0" cellspacing="1" bgcolor="#000000">
        		<tr bgcolor="e8e8e8" height="25">
          			<td  height="25"width="10%" ><div align="center"><span class=style4>�����ڿ���</span></div></td>
          			<td width="12%"><div align="center"><span class=style4>�����ڹ���</span></div></td>
          			<td colspan="2"><div align="center"><span class=style4>���谡�Գ���(�����ѵ�)</span></div></td>
          			<td colspan="2"><div align="center"><span class=style4>�ڱ��������� ����</span></div></td>
        		</tr>
        		<tr bgcolor="#FFFFFF" height="38">
          			<td height="38" rowspan="4"><div align="center"><span class=style4>��26��<br>�̻�</span></div></td>
          			<td rowspan="4" bgcolor="e8e8e8">
          				<table width="100%" border=0 cellspacing=0 cellpadding=0>
          					<tr>
          						<td><div align="left">&nbsp;<span class=style4>(1)�����</span></td>
          					</tr>
          					<tr>
          						<td height=3></td>
          					</tr>
          					<tr>
          						<td><div align="left">&nbsp;<span class=style4>(2)��༭��<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��õ�<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�߰�������</span></div></td>
          					</tr>
          				</table>
          			<td width="12%" bgcolor="e8e8e8"><div align="center"><span class=style4>���ι��</span></div></td>
          			<td width="15%" bgcolor="e8e8e8"><div align="center"><span class=style4>����<br>(���ι��,��)</span></div></td>
          			<td width="37%" rowspan="4" valign=top>
          				<table width=100% border=0 cellspacing=0 cellpadding=0>
          					<tr>
          						<td height=16></td>
          					</tr>
          					<tr>
          						<td><div align="left">&nbsp; <span class=style4>����1. �ڱ��������� ��å��(��� �Ǵ�)<br>
			          			&nbsp;&nbsp;&nbsp; <input type="checkbox" name="checkbox" value="checkbox" <%if(rf_bean.getCar_ja()==300000)%>checked<%%>> 30���� / <input type="checkbox" name="checkbox" value="checkbox" <%if(!String.valueOf(rf_bean.getCar_ja()).equals("300000"))%>checked<%%>> ��Ÿ(<%if(!String.valueOf(rf_bean.getCar_ja()).equals("300000") && rf_bean.getCar_ja()>=100000){%><%=rf_bean.getCar_ja()/10000%><%}else{%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%}%>)����</span><br><br>
			      				&nbsp; <span class=style3>(������ ��� �������ظ�å������ �ǰ� ����-������<br> 
			      				&nbsp; ���պ��� ���Ժ���� ����� ����. ��,������� �߻�<br>
			      				&nbsp; �ÿ��� ����������ġ[=�������ݡ�(1-(���ɰ�������<br>
			      				&nbsp; 0.01))]�� 20% �ݾ��� ���� �δ���.)</span></div></td>
			      			</tr>
			      		</table>
			      	</td>
          			<td width="14%" rowspan="4" valign=top>
          				<table width=100% border=0 cellspacing=0 cellpadding=0>
          					<tr>
          						<td height=16></td>
          					</tr>
          					<tr>
          						<td><div align="left">&nbsp; <span class=style4>����2.<br> &nbsp;&nbsp;�����Ⱓ ����<br>
          							&nbsp; �� ���������<br>&nbsp; <input type="checkbox" name="checkbox" value="checkbox" <%if(rf_bean.getMy_accid_yn().equals("Y")){%>checked<%}%>> ���δ�<br>&nbsp; <input type="checkbox" name="checkbox" value="checkbox" <%if(rf_bean.getMy_accid_yn().equals("N")){%>checked<%}%>> ����</span></div></td>
          					</tr>
          				</table>
          			</td>
        		</tr>
        		<tr bgcolor="e8e8e8" height="25">
          			<td height="25"><div align="center"><span class=style4>�빰���</span></div></td>
          			<td><div align="center"><span class=style4>1���</span></div></td>
        		</tr>
        		<tr bgcolor="e8e8e8" height="36">
          			<td height="36"><div align="center"><span class=style4>�ڱ��ü���</span></div></td>
          			<td><div align="center"><span class=style4>���/���� 1���<br>�λ� 1500����</span></div></td>
        		</tr>
        		<tr bgcolor="e8e8e8" height="25">
         	 		<td height="25"><div align="center"><span class=style4>������������</span></div></td>
          			<td><div align="center"><span class=style4>2���</span></div></td>
        		</tr>
        		<tr bgcolor="#FFFFFF" height="41">
          			<td height="41" colspan="6"><div align="left">&nbsp;&nbsp;<span class=style4>�� �������� : ���� ��å������ ���� ��� �߻���, �뿩������ �����Ⱓ�� �ش��ϴ� �뿩���(�Ƹ���ī �ܱⷻƮ ���ǥ<br> 
          			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;����)�� 50%�� ���� �δ��ϼž� �մϴ�. (�ڵ����뿩 ǥ�ؾ�� ��19���� ����)</span></div></td>
        		</tr>
      		</table>
      	</td>
	</tr>
	<tr>
		<td height=2></td>
	</tr>
	<tr>
		<td>
      		<table width="680" border="0" cellpadding="3" cellspacing="1" bgcolor="#000000">
		        <tr bgcolor="#FFFFFF" height="19">
		          	<td rowspan="3" width="13%"><div align="center">�Ƹ���ī<br>�ܱⷻƮ<br>���</div></td>
		          	<td><div align="center">�뿩����</div></td>
		          	<td colspan="4"><div align="center">�뿩�Ⱓ�� 1�� ��� (�ΰ��� ����)</div></td>
		        </tr>
		        <tr bgcolor="#FFFFFF" height="19">
		          	<td rowspan="2"><div align="center"><%=rf_bean.getCars()%></div></td>
		          	<td width="12%"><div align="center">1~2��</div></td>
		          	<td width="12%"><div align="center">3~4��</div></td>
		          	<td width="12%"><div align="center">5~6��</div></td>
		          	<td width="12%"><div align="center">7���̻�</div></td>
		        </tr>
		        <tr bgcolor="#FFFFFF" height="19">
		          	<td><div align="center"><%=AddUtil.parseDecimal(rf_bean.getAmt_01d()*1.1)%>��</div></td>
		          	<td><div align="center"><%=AddUtil.parseDecimal(rf_bean.getAmt_03d()*1.1)%>��</div></td>
		          	<td><div align="center"><%=AddUtil.parseDecimal(rf_bean.getAmt_05d()*1.1)%>��</div></td>
		          	<td><div align="center"><%=AddUtil.parseDecimal(rf_bean.getAmt_07d()*1.1)%>��</div></td>
		        </tr>
			</table>
		</td>
	</tr>
	<tr>
    	<td height=10></td>
    </tr>
	<tr>
    	<td><div align="left"><span class=style2><img src=/images/cardoc_arrow.gif> ��Ÿ�������</span></div></td>
    </tr>
	<tr>
		<td>
      		<table width="680" border="0" cellpadding="3" cellspacing="1" bgcolor="#000000">
		        <tr bgcolor="#FFFFFF" height="31">
		          	<td height="31" bgcolor="e8e8e8"><div align="center">����<br>����Ÿ�</div></td>
		          	<td><div align="left">&nbsp;<%if(rent_s_cd.equals("022197")){%>2,000km<%}else{%>5,000km<%}%> / 1����, �ʰ��� 1km�� <%=AddUtil.parseDecimal(rf_bean.getOver_run_amt())%>���� �߰������ �ΰ��˴ϴ�.</div></td>
		        </tr>
		        <tr bgcolor="e8e8e8" height="31">
		          	<td height="31" ><div align="center">������<br>����</div></td>
		          	<td bgcolor="e8e8e8"><div align="left">&nbsp;<span class=style4><b>�� ����� ����Ʈ(�����)�� Ư���� ������ ������ ���� �ʽ��ϴ�.<br>
		      			&nbsp;�̿��ڲ����� ������ �����Ͻþ� �̿��Ͻñ� �ٶ��ϴ�.</b></span></div></td>
		        </tr>
		        <tr bgcolor="#FFFFFF" height="50">
		          	<td height="50" bgcolor="e8e8e8"><div align="center">���·�<br>��������<br>����</div></td>
		          	<td><div align="left">&nbsp;<span class=style4>1) ������ �����Ⱓ �� �߻��Ǵ� ������ ���� �� ������� ���� ���·�� ��Ģ�� ���� ���� �δ��Ͽ��� �մϴ�.<br>
		      			&nbsp;2) ���� �̿� �� ����(�������, �������� ��ȯ ��)�� �ʿ��� ��� ���� �Ƹ���ī ��������ڿ��� �����Ͽ��� �ϸ�,<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		      			 ���� ����� �Ƹ���ī ���������ü�� ���� �湮�� �ּž� �մϴ�. ������ �Ƹ���ī���� �����ϸ�,<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ���κ������ ó���� ���ó���� �ȵ˴ϴ�.<br>
		      			&nbsp;3) ���� �̿� �� ��� �߻����� ��� ���� �Ƹ���ī ��������ڿ��� �����Ͽ��� �մϴ�.</span></div></td>
		        </tr>
		        <tr bgcolor="#FFFFFF" height="45">
		          	<td height="45" bgcolor="e8e8e8"><div align="center">��� ����</div></td>
		          	<td><div align="left">&nbsp;<span class=style4>1) ���ʰ��Ⱓ���� �����Ͽ� �̿��ϰ��� �� ��쿡��</span> <span class=style2>��ุ�� 7��(<%=AddUtil.ChangeDate2(end_dt7)%>)������</span><span class=style4> ����� ������<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�޾ƾ� �մϴ�.<br>
		      			&nbsp;2) ����뿩����� ����뿩������ �Ϸ����� CMS�ڵ���ü�� �Ƹ���ī�� ����մϴ�.<br>
		      			&nbsp;&nbsp;&nbsp;&nbsp; ���� �뿩������ �Ϸ������� �뿩����� �������� ������ ��࿬���� �������� �ʽ��ϴ�.<br>
		      			&nbsp;<b>�� ��࿬�� ����� ���Բ��� ���� �Ƹ���ī�� �����ϼž� �ϸ�, ������ ������ ������ �������� �ʴ� <br>
		      			&nbsp;&nbsp;&nbsp;&nbsp; ������ �����մϴ�.</b></span> <span class=style2>(�Ƹ���ī ��࿬������ : <%=user_bean3.getUser_nm()%>  <%=user_bean3.getUser_pos()%>
		      			    <%if(user_bean3.getUser_nm().equals("���¿�")){%>02-392-4242
			        	    <%}else{%><%=user_bean3.getUser_m_tel()%><%}%>)</span></div></td>
		        </tr>
		        <tr bgcolor="e8e8e8" height="31">
		          	<td height="31"><div align="center">�뿩��<br>��ü��</div></td>
		          	<td bgcolor="e8e8e8"><div align="left">&nbsp;<span class=style4>1) �뿩�� ��ü�ÿ��� �Ӵ����� ��� ����� ������ �� ������, �� �� �������� ������ ��� �ݳ��Ͽ��� �մϴ�.<br>
 	      			&nbsp;2) �뿩�� ��ü�� �⸮ 24%�� ��ü���ڰ� �ΰ��˴ϴ�.</span></div></td>
		        </tr>
		        <tr bgcolor="e8e8e8" height="31">
		          	<td height="31"><div align="center">�ߵ�������</div></td>
		          	<td bgcolor="e8e8e8"><div align="left">&nbsp;<span class=style4>1) ���̿�Ⱓ�� <%if(day_cnt==30){%>1����<%}else{%><%=day_cnt%>��<%}%> �̻��� ��� : �ܿ��Ⱓ �뿩����� 10%�� ������� �ΰ��˴ϴ�.<br>
		      			&nbsp;2) ���̿�Ⱓ�� <%if(day_cnt==30){%>1����<%}else{%><%=day_cnt%>��<%}%> �̸��� ��� : �Ʒ� ��õ� ������� ����� �����ϴ�.</span></div></td>
		        </tr>
		        <tr bgcolor="#FFFFFF" height="45">
		          	<td height="45" bgcolor="e8e8e8"><div align="center">��Ÿ<br>Ư�̻���</div></td>
		          	<td><div align="left">&nbsp;<%=rc_bean.getEtc()%></div></td>
		        </tr>
      		</table>
		</td>
	</tr>
	<tr>
		<td><div align="left">&nbsp;<span class=style4>�� �� ��༭�� ������� ���� ������ "�ڵ��� �뿩 ǥ�ؾ��"�� ���մϴ�. (�Ƹ���ī ����Ʈ ���� Ȩ������ ����)</span></div></td>
	<tr>
    	<td height=5></td>
    </tr>
	<tr>
    	<td><div align="left"><span class=style2><img src=/images/cardoc_arrow.gif> ���̿�Ⱓ�� <%if(day_cnt==30){%>1����<%}else{%><%=day_cnt%>��<%}%> �̸��� ����� �������</span> <span class=style4>(�Ʒ� ���ؿ� �ǰ� �̿��� �� ��ŭ�� �뿩�ᰡ ����˴ϴ�.)
    	&nbsp;&nbsp;<span class=style3>�� ����:��, %</span></div></td>
    </tr>
	<tr>
		<td>
      		<table width="680" border="0" cellpadding="2" cellspacing="1" bgcolor="#000000">
        		<tr bgcolor="#E8E8E8" height="19">
		          	<td width="107" height="19"><div align="center"><span class=style3>�̿��ϼ�</span></div></td>
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
        		<tr bgcolor="#FFFFFF" height="25">
		          	<td height="25" bgcolor="e8e8e8"><div align="center"><span class=style3>���뿩��<br>���������</span></div></td>
		          	<%for (int j = 0 ; j < 30 ; j++){%>
		                <td bgcolor=#ffffff align=center><span class=style4><%if(day_per[j]>0){%><%=day_per[j]%><%}%></span></td>
		                <%}%>
        		</tr>
     		</table>
     	</td>
	</tr>
	<tr>
		<td height=7></td>
	</tr>		
	<tr>
		<td>
			<table width="680" border="0" cellpadding="3" cellspacing="1" bgcolor="#000000">
				<tr>
					<td height=18 bgcolor="#FFFFFF" colspan=4><div align="center"><span class=style2>����� &nbsp;&nbsp;: &nbsp;&nbsp;<%=rc_bean.getRent_dt().substring(0,4)%>�� &nbsp;&nbsp;<%=rc_bean.getRent_dt().substring(4,6)%>�� &nbsp;&nbsp;<%=rc_bean.getRent_dt().substring(6,8)%>��</span></div></td>
				</tr>
		        <tr bgcolor="#FFFFFF">
		          	<td width="46%" height=130 style="padding-top:8px; padding-bottom:5px;"><div align="left">&nbsp;&nbsp;<span class=style2>�뿩������(�Ӵ���)</span><br>&nbsp;&nbsp;<span class=style4>����� �������� ���ǵ��� 17-3 ��ȯ��º��� 802ȣ</span><br><br><br><br><br><br>
		      			&nbsp;&nbsp;<span class=style6>(��)�Ƹ���ī ��ǥ�̻� &nbsp;&nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;�� &nbsp;&nbsp;�� &nbsp;(��)</span></div></td>
		          	<td colspan="3" style="padding-top:8px; padding-bottom:5px;"><div align="left">&nbsp;&nbsp;&nbsp;<span class=style2>�뿩�̿��� (������)</span><br>
		      			&nbsp;&nbsp;&nbsp;<span class=style4>�� ����� ������ Ȯ���Ͽ� ����� ü���ϰ� ��༭ 1���� ����<br>&nbsp;&nbsp;&nbsp;������.<br>
		      			&nbsp;&nbsp;&nbsp;�� �뿩�̿���</span><br><br><br><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class=style5>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		      			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;		      			
		      			(��)</span></div></td>
		        </tr>
		        <tr bgcolor="#FFFFFF" height="20">
		          	<td height="20" rowspan="3"><div align="left">&nbsp;<span class=style3>�� ���뺸������ �������� (��)�Ƹ���ī�� ü���� �� &quot;�ڵ���<br>
		          	&nbsp;�뿩 ���&quot; �̿뿡 ���Ͽ� �� ������ �����ϰ� �����ΰ� ���� <br>
		          	&nbsp;�Ͽ� ������ ��ü�� ä�ǡ�ä���� ������ ���� Ȯ���մϴ�.</span></div></td>
		          	<td width="9%" rowspan="3"><div align="center"><span class=style6>����<br>������</span></div></td>
		          	<td width="13%"><div align="center">�� �� </div></td>
		          	<td width="34%"><div align="left">&nbsp;<%=rm_bean3.getAddr()%></div></td>
		        </tr>
		        <tr bgcolor="#FFFFFF" height="20">
		          	<td height="20"><div align="center">�ֹε�Ϲ�ȣ</div></td>
		          	<td><div align="left">&nbsp;<%=rm_bean3.getSsn()%></div></td>
		        </tr>
		        <tr bgcolor="#FFFFFF" height="20">
		          	<td height="20"><div align="center">����</div></td>
		          	<td><div align="right"><%=rm_bean3.getMgr_nm()%>(��)</div></td>
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
    				<td align=right>(����ȣ <%=rent_s_cd%> : Page 2/2)&nbsp;</td>
    			</tr>
    		</table>
    	</td>
    </tr>
</table>
</div>
</body>
</html>

<script>
function onprint(){

factory.printing.header = ""; //��������� �μ�
factory.printing.footer = ""; //�������ϴ� �μ�
factory.printing.portrait = true; //true-�����μ�, false-�����μ�    
factory.printing.leftMargin = 10.0; //��������   
factory.printing.topMargin = 10.0; //��ܿ���    
factory.printing.rightMargin = 10.0; //��������
factory.printing.bottomMargin = 8.0; //�ϴܿ���
factory.printing.Print(true, window);//arg1-��ȭ����ǥ�ÿ���(true or false), arg2-��ü������orƯ��������
}
</script>
