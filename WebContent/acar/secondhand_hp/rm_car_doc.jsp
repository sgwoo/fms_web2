<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.res_search.*, acar.estimate_mng.*, acar.secondhand.*, acar.user_mng.*" %>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>



<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	EstiDatabase 		e_db 	= EstiDatabase.getInstance();
	
	
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
	//�ڵ�����������
	String ins_com_id = shDb.getCarInsCom(car_mng_id);
	
	//��������
	EstimateBean e_bean = new EstimateBean();
	
	e_bean = e_db.getEstimateShCase(rf_bean.getEst_id());
	
	
	
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
<div id="Layer1" style="position:absolute; left:250px; top:1930px; width:54px; height:41px; z-index:1"><img src="/acar/main_car_hp/images/stamp.png" width="75" height="75"></div>
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
			<table width="680" border="0" cellpadding="3" cellspacing="1" bgcolor="#000000">
		      		<tr bgcolor="#FFFFFF" height="21">
			        	<td width="13%" height="21" bgcolor="e8e8e8"><div align="center">����ȣ</div></td>
			        	<td width="21%"><div align="left">&nbsp;<%=rent_s_cd%></div></td>
			        	<td width="13%" bgcolor="e8e8e8"><div align="center">������</div></td>
			        	<td width="20%"><div align="left">&nbsp;<%=c_db.getNameById(rc_bean.getBrch_id(),"BRCH")%></div></td>
			        	<td width="13%" bgcolor="e8e8e8"><div align="center">�����</div></td>
			        	<td width="20%"><div align="left">&nbsp;<%=c_db.getNameById(rc_bean.getBus_id(),"USER")%></div></td>
		      		</tr>
				<tr bgcolor="#FFFFFF" height="21">
			        	<td bgcolor="e8e8e8" height="21"><div align="center">������</div></td>
			        	<td><div align="left">&nbsp;<%=rc_bean2.getCust_st()%></div></td>
			        	<td bgcolor="e8e8e8"><div align="center">�뿩����</div></td>
			        	<td colspan="3"><div align="left">&nbsp;<%if(rent_st.equals("1")){%>
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
		        <tr bgcolor="#FFFFFF" height="21">
		          	<td width="13%" height="21"><div align="center">����(��ǥ��)</div></td>
		          	<td width="34%" colspan="2"><div align="left">&nbsp;<%=rc_bean2.getCust_nm()%></div></td>
		          	<td width="18%"><div align="center">�ֹ�(����)��Ϲ�ȣ</div></td>
		          	<td colspan="2"><div align="left">&nbsp;<%=rc_bean2.getSsn()%></div></td>
		        </tr>
		        <tr bgcolor="#FFFFFF" height="21">
		          	<td height="21"><div align="center">��ȣ</div></td>
		         	 <td colspan="2"><div align="left">&nbsp;<%=rc_bean2.getFirm_nm()%></div></td>
		          	<td><div align="center">����ڵ�Ϲ�ȣ</div></td>
		          	<td colspan="2"><div align="left">&nbsp;<%=rc_bean2.getEnp_no()%></div></td>
		        </tr>
		        <tr bgcolor="#FFFFFF" height="21">
		          	<td height="21"><div align="center">�ּ�</div></td>
		          	<td colspan="5"><div align="left">&nbsp;<%=rc_bean2.getAddr()%></div></td>
		        </tr>
		        <tr bgcolor="#FFFFFF" height="21">
		          	<td height="21"><div align="center">���������ȣ</div></td>
		          	<td colspan="2"><div align="left">&nbsp;<%=rm_bean4.getLic_no()%></div></td>
		         	<td rowspan="2"><div align="center">����ó</div></td>
		          	<td width="9%"><div align="center">��ȭ��ȣ </div></td>
		          	<td width="26%"><div align="left">&nbsp;<%=rm_bean4.getTel()%></div></td>
		        </tr>
		        <tr bgcolor="#FFFFFF" height="21">
		          	<td height="21"><div align="center">��������</div></td>
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
	<tr><td></td></tr>
	<tr>
		<td>	
			<table width="680" border="0" cellpadding="3" cellspacing="1" bgcolor="#000000">
		        <tr bgcolor="#FFFFFF" height="21">
		          	<td width="85" rowspan="4"><div align="center">�߰�������</div></td>
		          	<td height="21" width="64"><div align="center">����</div></td>
		         	<td width="162"><div align="left">&nbsp;<%=rm_bean1.getMgr_nm()%></div></td>
		          	<td width="121"><div align="center">�ֹε�Ϲ�ȣ</div></td>
		          	<td width="242" colspan="2"><div align="left">&nbsp;<%=rm_bean1.getSsn()%></div></td>
		        </tr>
		        <tr bgcolor="#FFFFFF" height="21">
		          	<td height="21"><div align="center">�ּ�</div></td>
		         	<td colspan="4"><div align="left">&nbsp;<%=rm_bean1.getAddr()%></div></td>
		        </tr>
		        <tr bgcolor="#FFFFFF" height="21">
		          	<td height="21"><div align="center">��ȭ��ȣ</div></td>
		          	<td><div align="left">&nbsp;<%=rm_bean1.getTel()%></div></td>
		          	<td><div align="center">���������ȣ</div></td>
		          	<td colspan="2"><div align="left">&nbsp;<%=rm_bean1.getLic_no()%></div></td>
		        </tr>
		        <tr bgcolor="#FFFFFF" height="21">
		          	<td height="21"><div align="center">��Ÿ</div></td>
		          	<td colspan="4"><div align="left">&nbsp;<%=rm_bean1.getEtc()%></div></td>
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
        		<tr bgcolor="e8e8e8" height="21">
		          	<td  height="21"width="13%" ><div align="center">����</div></td>
		          	<td colspan="4"><div align="left">&nbsp;<%=reserv.get("CAR_NM")%>&nbsp;<%=reserv.get("CAR_NAME")%></div></td>
		          	<td width="13%"><div align="center">������ȣ</div></td>
		          	<td width="20%"><div align="left">&nbsp;<%=reserv.get("CAR_NO")%></div></td>
       		 	</tr>
        		<tr bgcolor="e8e8e8" height="21">
		          	<td height="21"><div align="center">��������</div></td>
		          	<td colspan="2"><div align="left">&nbsp;<%=reserv.get("FUEL_KD")%></div></td>
		          	<td width="13%"><div align="center">��������Ÿ�</div></td>
		          	<td width="20%"><div align="left">&nbsp;<%=AddUtil.parseDecimal(rf_bean.getDist_km())%>km</div></td>
		          	<td><div align="center">�߰��뿩ǰ��</div></td>
		          	<td><div align="left">&nbsp;<%if(rf_bean.getNavi_yn().equals("Y")){%>��ġ��������̼�<%}%></div></td>
        		</tr>
        		<tr bgcolor="e8e8e8" height="21">
		          	<td  height="21"rowspan="3"><div align="center">�̿�Ⱓ</div></td>
		          	<td width="9%"><div align="center">�Ⱓ</div></td>
		          	<td colspan="5"><div align="left">&nbsp;<%=rc_bean.getRent_months()%>����
		          	<%if(!rc_bean.getRent_days().equals("0")){%><%=rc_bean.getRent_days()%>��<%}%>
		          	</div></td>
		        </tr>
		        <tr bgcolor="e8e8e8" height="21">
		          	<td height="21"><div align="center">��¥</div></td>
		          	<td colspan="5"><div align="left">&nbsp;<%=AddUtil.ChangeDate2(rc_bean.getRent_start_dt_d())%> <!--<%=rc_bean.getRent_start_dt_h()%>�� <%=rc_bean.getRent_start_dt_s()%>��--> ~ <%=AddUtil.ChangeDate2(rc_bean.getRent_end_dt_d())%> <!--<%=rc_bean.getRent_end_dt_h()%>�� <%=rc_bean.getRent_end_dt_s()%>��--></div></td>
		        </tr>
		        <tr bgcolor="e8e8e8" height="21">
		          	<td height="21" colspan="6"><div align="left">&nbsp;�뿩����� �������� �����ϸ�, 1���� �̸��� ���������Ͽ��� �� ��쿡�� 30���� 1������ ���ϴ�.</div></td>
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
		        	<td height="20" width="9%"><div align="center">����</div></td>
		          	<td><div align="left">&nbsp;<%if(rc_bean.getDeli_dt_d().equals("")){%><%=AddUtil.ChangeDate2(rc_bean.getDeli_plan_dt_d())%> <%=rc_bean.getDeli_plan_dt_h()%>��<%=rc_bean.getDeli_plan_dt_s()%>��<%}else{%><%=AddUtil.ChangeDate2(rc_bean.getDeli_dt_d())%> <%=rc_bean.getDeli_dt_h()%>��<%=rc_bean.getDeli_dt_s()%>��<%}%></div></td>
		          	<td width="9%"><div align="center">����</div></td>
		        	<td><div align="left">&nbsp;<%if(rc_bean.getRet_dt_d().equals("")){%><%=AddUtil.ChangeDate2(rc_bean.getRet_plan_dt_d())%> <%=rc_bean.getRet_plan_dt_h()%>��<%=rc_bean.getRet_plan_dt_s()%>��<%}else{%><%=AddUtil.ChangeDate2(rc_bean.getRet_dt_d())%> <%=rc_bean.getRet_dt_h()%>��<%=rc_bean.getRet_dt_s()%>��<%}%></div></td>
		        </tr>
		        <tr bgcolor="#FFFFFF" height="20">
		          	<td height="20"><div align="center">���</div></td>
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
		          	<td colspan="4" bgcolor="e8e8e8" height="26"><div align="center">���뿩��</div></td>
		          	<td width="13%" bgcolor="e8e8e8"><div align="center">�뿩�� �Ѿ�</div></td>
		          	<td width="13%" rowspan="2" bgcolor="e8e8e8"><div align="center">������</div></td>
		          	<td width="13%" rowspan="2" bgcolor="e8e8e8"><div align="center">������</div></td>
		        </tr>
		        <tr>
		          	<td height="26" width="12%" bgcolor="e8e8e8"><div align="center">����</div></td>
		          	<td width="12%" bgcolor="e8e8e8"><div align="center">������̼�</div></td>
		        	<td width="12%" bgcolor="e8e8e8"><div align="center">��Ÿ</div></td>
		          	<td width="12%" bgcolor="e8e8e8"><div align="center">�հ�</div></td>
		          	<td bgcolor="e8e8e8"><div align="center"><%=rc_bean.getRent_months()%>����
		          	<%if(!rc_bean.getRent_days().equals("0")){%><%=rc_bean.getRent_days()%>��<%}%></div></td>
		        </tr>
		        <tr>
		          	<td height="26" bgcolor="e8e8e8"><div align="center">���ް�</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(rf_bean.getInv_s_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(rf_bean.getNavi_s_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(rf_bean.getEtc_s_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(rf_bean.getInv_s_amt()+rf_bean.getNavi_s_amt()+rf_bean.getEtc_s_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(rf_bean.getFee_s_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(rf_bean.getCons1_s_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(rf_bean.getCons2_s_amt())%>&nbsp;</div></td>
		        </tr>
		        <tr>
		          	<td height="26" bgcolor="e8e8e8"><div align="center">�ΰ���</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(rf_bean.getInv_v_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(rf_bean.getNavi_v_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(rf_bean.getEtc_v_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(rf_bean.getInv_v_amt()+rf_bean.getNavi_v_amt()+rf_bean.getEtc_v_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(rf_bean.getFee_v_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(rf_bean.getCons1_v_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(rf_bean.getCons2_v_amt())%>&nbsp;</div></td>
		        </tr>
		        <tr>
		          	<td height="26" bgcolor="e8e8e8"><div align="center">�հ�</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(rf_bean.getInv_s_amt()+rf_bean.getInv_v_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(rf_bean.getNavi_s_amt()+rf_bean.getNavi_v_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(rf_bean.getEtc_s_amt()+rf_bean.getEtc_v_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(rf_bean.getInv_s_amt()+rf_bean.getInv_v_amt()+rf_bean.getNavi_s_amt()+rf_bean.getNavi_v_amt()+rf_bean.getEtc_s_amt()+rf_bean.getEtc_v_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(rf_bean.getFee_s_amt()+rf_bean.getFee_v_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(rf_bean.getCons1_s_amt()+rf_bean.getCons1_v_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(rf_bean.getCons2_s_amt()+rf_bean.getCons2_v_amt())%>&nbsp;</div></td>
		        </tr>
		        <tr>
		          	<td height="26" bgcolor="e8e8e8" style="border-bottom:1px solid #000000;"><div align="center">�������</div></td>
		          	<td colspan="5" bgcolor="e8e8e8" style="border-bottom:1px solid #000000;"><div align="left">&nbsp;<%if(rf_bean.getF_paid_way().equals("1")){%>1����ġ��<%}%> <%if(rf_bean.getF_paid_way().equals("2")){%>�뿩�� ���� <%}%>
		          	  <%if(rf_bean.getPaid_way().equals("1")){%>����<%}%><%if(rf_bean.getPaid_way().equals("2")){%>�ĺ�<%}%>
		          	  </div></td>
		          	<td colspan="2" bgcolor="e8e8e8" style="border-bottom:1px solid #000000;"><div align="left">&nbsp;��/������� �����Դϴ�</div></td>
		        </tr>
		        <tr>
		        	<td height="26" bgcolor="e8e8e8"><div align="center">���ʰ����ݾ�</div></td>
		        	<td colspan="7" bgcolor="e8e8e8"><div align="left">&nbsp;<%=AddUtil.parseDecimal(rf_bean.getF_rent_tot_amt())%>��, 
		        	<%if(rf_bean.getF_paid_way().equals("1")){%>ùȸ�� �뿩��<%}%>
		        	<%if(rf_bean.getF_paid_way().equals("2")){%>�뿩�� �Ѿ�<%}%>
		        	
		        	<%if(rf_bean.getCons1_s_amt()>0){%>+ ������<%}%>
		        	<%if(rf_bean.getF_paid_way2().equals("1")){%>+ ������<%}%>
		        	 
		        	
		        	</div></td>
		        </tr>
		        <tr>
		        	<td height="44" bgcolor="e8e8e8"><div align="center">���</div></td>
		        	<td colspan="4" bgcolor="e8e8e8"><div align="left">&nbsp;<%=rf_bean.getFee_etc()%></div></td>
		          	<td bgcolor="e8e8e8"><div align="center">��������</div></td>
		          	<td colspan="2" bgcolor="e8e8e8"><div align="left">&nbsp;<%if(rf_bean.getPaid_st().equals("1")){%>����<%}%>
                            	      <%if(rf_bean.getPaid_st().equals("2")){%>�ſ�ī��<%}%>
                            	      <%if(rf_bean.getPaid_st().equals("3")){%>�ڵ���ü<%}%>
                            	      <%if(rf_bean.getPaid_st().equals("4")){%>�������Ա�<%}%></div></td>
		        </tr>
      		</table>
      	</td>
	</tr>
	<tr><td></td></tr>
	<tr>
		<td>
			<table width="680" border="0" cellpadding="0" cellspacing="1" bgcolor="#000000">
				<tr bgcolor="#FFFFFF">
          			<td width="13%" rowspan=3 bgcolor="e8e8e8"><div align="center">�ڵ���ü<br>��û</div></td>
          			<td width="13%" height="38"><div align="center">�ڵ���ü<br>�������¹�ȣ</div></td>
          			<td width="35%" style="line-height:20px;">     			
          			<%if(rf_bean.getCms_bank().equals("")){%>
          			<div align="left">&nbsp;&nbsp;&nbsp;&nbsp;<span class=style5>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><br>
          			(&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;����&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;����&nbsp;&nbsp;)</div>
          			<%}else{%>
          			<div align="center"><span class=style5>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=rf_bean.getCms_acc_no()%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><br>
          			(&nbsp;&nbsp;<%=rf_bean.getCms_bank()%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;����&nbsp;&nbsp;)</div>
          			<%}%>
          			</td>
          			<td width="13%"><div align="center">������<br>(�뿩�̿���)</div></td>
          			<td width="26%"><div align="right"><%=rf_bean.getCms_dep_nm()%>&nbsp;(��)&nbsp;</div></td>
        		</tr>
        		<tr bgcolor="#FFFFFF" height="38">
        			<td height="42">�ڵ���ü<br>���</td>
        			<td colspan="3"><div align="left"> &nbsp;�뿩��, ��ü����, �ߵ����������, ��å��, ���·�, ������, ������</div></td>
        		</tr>
        		<tr bgcolor="#FFFFFF">
        			<td colspan="4" height="38"><div align="left">&nbsp;&nbsp;�� ���� ���õ� �뿩�� �� ��Ÿ ä���� �����Կ� �־�, ��(�뿩�̿���)�� �������� ������<br>
        			&nbsp;&nbsp;������ ��� �Ƹ���ī�� �ش�ݾ��� �ڵ���ü�� ���</div>
        			</td>
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
    	<td><div align="left"><span class=style2><img src=/images/cardoc_arrow.gif> ������� �� ��å�ӻ���</span>
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
        		<tr bgcolor="e8e8e8" height="27">
          			<td  height="27"width="10%" ><div align="center"><span class=style4>�����ڿ���</span></div></td>
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
			      	</tr>
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
	<tr><td></td></tr>
	<tr>
		<td>
      		<table width="680" border="0" cellpadding="3" cellspacing="1" bgcolor="#000000">
		        <tr bgcolor="#FFFFFF" height="21">
		          	<td height="21" rowspan="3" width="13%"><div align="center">�Ƹ���ī<br>�ܱⷻƮ<br>���</div></td>
		          	<td><div align="center">�뿩����</div></td>
		          	<td colspan="4"><div align="center">�뿩�Ⱓ�� 1�� ��� (�ΰ��� ����)</div></td>
		        </tr>
		        <tr bgcolor="#FFFFFF" height="20">
		          	<td height="20" rowspan="2"><div align="center"><%=rf_bean.getCars()%></div></td>
		          	<td width="12%"><div align="center">1~2��</div></td>
		          	<td width="12%"><div align="center">3~4��</div></td>
		          	<td width="12%"><div align="center">5~6��</div></td>
		          	<td width="12%"><div align="center">7���̻�</div></td>
		        </tr>
		        <tr bgcolor="#FFFFFF" height="21">
		          	<td height="21"><div align="center"><%=AddUtil.parseDecimal(rf_bean.getAmt_01d()*1.1)%>��</div></td>
		          	<td><div align="center"><%=AddUtil.parseDecimal(rf_bean.getAmt_03d()*1.1)%>��</div></td>
		          	<td><div align="center"><%=AddUtil.parseDecimal(rf_bean.getAmt_05d()*1.1)%>��</div></td>
		          	<td><div align="center"><%=AddUtil.parseDecimal(rf_bean.getAmt_07d()*1.1)%>��</div></td>
		        </tr>
			</table>
		</td>
	</tr>
	<tr>
    	<td height=13></td>
    </tr>
	<tr>
    	<td><div align="left"><span class=style2><img src=/images/cardoc_arrow.gif> ��Ÿ�������</span></div></td>
    </tr>
	<tr>
		<td>
      		<table width="680" border="0" cellpadding="3" cellspacing="1" bgcolor="#000000">
		        <tr bgcolor="#FFFFFF" height="34">
		          	<td height="34" bgcolor="e8e8e8"><div align="center">����<br>����Ÿ�</div></td>
		          	<td><div align="left">&nbsp;<%if(rent_s_cd.equals("022197")){%>2,000km<%}else{%>5,000km<%}%> / 1����, �ʰ��� 1km�� <%=AddUtil.parseDecimal(rf_bean.getOver_run_amt())%>���� �߰������ �ΰ��˴ϴ�.</div></td>
		        </tr>
		        <tr bgcolor="e8e8e8" height="34">
		          	<td height="34" ><div align="center">������ ����</div></td>
		          	<td bgcolor="e8e8e8"><div align="left">&nbsp;<span class=style4><b>�� ����� ����Ʈ(�����)�� Ư���� ������ ������ ���� �ʽ��ϴ�.<br>
		      			&nbsp;�̿��ڲ����� ������ �����Ͻþ� �̿��Ͻñ� �ٶ��ϴ�.</b></span></div></td>
		        </tr>
		        <tr bgcolor="#FFFFFF" height="80">
		          	<td height="80" bgcolor="e8e8e8"><div align="center">���·�<br>��������<br>����</div></td>
		          	<td><div align="left">&nbsp;<span class=style4>1) ������ �����Ⱓ �� �߻��Ǵ� ������ ���� �� ������� ���� ���·�� ��Ģ�� ���� ���� �δ��Ͽ���<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�մϴ�.<br>
		      			&nbsp;2) ���� �̿� �� ����(�������, �������� ��ȯ ��)�� �ʿ��� ��� ���� �Ƹ���ī ��������ڿ��� �����Ͽ��� �ϸ�,<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		      			 ���� ����� �Ƹ���ī ���������ü�� ���� �湮�� �ּž� �մϴ�. ������ �Ƹ���ī���� �����ϸ�,<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ���κ������ ó���� ���ó���� �ȵ˴ϴ�.<br>
		      			&nbsp;3) ���� �̿� �� ��� �߻����� ��� ���� �Ƹ���ī ��������ڿ��� �����Ͽ��� �մϴ�.</span></div></td>
		        </tr>
		        <tr bgcolor="#FFFFFF" height="34">
		          	<td height="34" bgcolor="e8e8e8"><div align="center">��� ����</div></td>
		          	<td><div align="left">&nbsp;<span class=style4>1) ���ʰ��Ⱓ���� �����Ͽ� �̿��ϰ��� �� ��쿡�� ������ ����� ������ �޾ƾ� �մϴ�.<br>
		      			&nbsp;2) ����� ������ ���� �� �߰��̿�Ⱓ�� ���� �뿩�Ḧ ���ҷ� �����Ͽ��� ��࿬���� �����˴ϴ�.</span</div></td>
		        </tr>
		        <tr bgcolor="e8e8e8" height="34">
		          	<td height="34"><div align="center">�ߵ�������</div></td>
		          	<td bgcolor="e8e8e8"><div align="left">&nbsp;<span class=style4>1) ���̿�Ⱓ�� 1���� �̻��� ��� : �ܿ��Ⱓ �뿩����� 10%�� ������� �ΰ��˴ϴ�.<br>
		      			&nbsp;2) ���̿�Ⱓ�� 1���� �̸��� ��� : �Ʒ� ��õ� ������� ����� �����ϴ�.</span></div></td>
		        </tr>
		        <tr bgcolor="#FFFFFF" height="45">
		          	<td height="45" bgcolor="e8e8e8"><div align="center">��Ÿ<br>Ư�̻���</div></td>
		          	<td><div align="left">&nbsp;<%=rc_bean.getEtc()%></div></td>
		        </tr>
      		</table>
		</td>
	</tr>

	<tr>
    	<td height=13></td>
    </tr>
	<tr>
    	<td><div align="left"><span class=style2><img src=/images/cardoc_arrow.gif> ���̿�Ⱓ�� 1���� �̸��� ����� �������</span> <span class=style4>(�Ʒ� ���ؿ� �ǰ� �̿��� �� ��ŭ�� �뿩�ᰡ ����˴ϴ�.)
    	&nbsp;&nbsp;<span class=style3>�� ����:��, %</span></div></td>
    </tr>
	<tr>
		<td>
      		<table width="680" border="0" cellpadding="2" cellspacing="1" bgcolor="#000000">
        		<tr bgcolor="#E8E8E8" height="21">
		          	<td width="107" height="21"><div align="center"><span class=style3>�̿��ϼ�</span></div></td>
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
        		<tr bgcolor="#FFFFFF" height="28">
		          	<td height="28" bgcolor="e8e8e8"><div align="center"><span class=style3>���뿩����<br>������</span></div></td>
		          	<td><div align="center"><span class=style3>31</span></div></td>
		          	<td><div align="center"><span class=style3>37</span></div></td>
		          	<td><div align="center"><span class=style3>42</span></div></td>
		          	<td><div align="center"><span class=style3>46</span></div></td>
		          	<td><div align="center"><span class=style3>50</span></div></td>
		          	<td><div align="center"><span class=style3>53</span></div></td>
		          	<td><div align="center"><span class=style3>56</span></div></td>
		          	<td><div align="center"><span class=style3>59</span></div></td>
		          	<td><div align="center"><span class=style3>62</span></div></td>
		          	<td><div align="center"><span class=style3>64</span></div></td>
		          	<td><div align="center"><span class=style3>66</span></div></td>
		          	<td><div align="center"><span class=style3>69</span></div></td>
		          	<td><div align="center"><span class=style3>71</span></div></td>
		          	<td><div align="center"><span class=style3>73</span></div></td>
		          	<td><div align="center"><span class=style3>75</span></div></td>
		          	<td><div align="center"><span class=style3>77</span></div></td>
		          	<td><div align="center"><span class=style3>79</span></div></td>
		          	<td><div align="center"><span class=style3>81</span></div></td>
		          	<td><div align="center"><span class=style3>83</span></div></td>
		          	<td><div align="center"><span class=style3>84</span></div></td>
		          	<td><div align="center"><span class=style3>86</span></div></td>
		          	<td><div align="center"><span class=style3>88</span></div></td>
		          	<td><div align="center"><span class=style3>89</span></div></td>
		          	<td><div align="center"><span class=style3>91</span></div></td>
		          	<td><div align="center"><span class=style3>93</span></div></td>
		          	<td><div align="center"><span class=style3>94</span></div></td>
		          	<td><div align="center"><span class=style3>96</span></div></td>
		          	<td><div align="center"><span class=style3>97</span></div></td>
		          	<td><div align="center"><span class=style3>99</span></div></td>
		          	<td><div align="center"><span class=style3>100</span></div></td>
        		</tr>
     		</table>
     	</td>
	</tr>
	<tr>
		<td height=13></td>
	</tr>		
	<tr>
		<td>
			<table width="680" border="0" cellpadding="3" cellspacing="1" bgcolor="#000000">
				<tr>
					<td height=24 bgcolor="#FFFFFF" colspan=4><div align="center"><span class=style2>����� &nbsp;&nbsp;: &nbsp;&nbsp;<%=rc_bean.getRent_dt().substring(0,4)%>�� &nbsp;&nbsp;<%=rc_bean.getRent_dt().substring(4,6)%>�� &nbsp;&nbsp;<%=rc_bean.getRent_dt().substring(6,8)%>��</span></div></td>
				</tr>
		        <tr bgcolor="#FFFFFF">
		          	<td width="44%" height=155 style="padding-top:8px; padding-bottom:5px;"><div align="left">&nbsp;&nbsp;<span class=style2>�뿩������(�Ӵ���)</span><br>&nbsp;&nbsp;<span class=style4>����� �������� ���ǵ��� 17-3 ��ȯ��º��� 802ȣ</span><br><br><br><br><br><br><br><br>
		      			&nbsp;&nbsp;<span class=style6>(��)�Ƹ���ī ��ǥ�̻� &nbsp;&nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;�� &nbsp;&nbsp;�� &nbsp;(��)</span></div></td>
		          	<td colspan="3" style="padding-top:8px; padding-bottom:5px;"><div align="left">&nbsp;&nbsp;&nbsp;<span class=style2>�뿩�̿��� (������)</span><br>
		      			&nbsp;&nbsp;&nbsp;<span class=style4>�� ����� ������ Ȯ���Ͽ� ����� ü���ϰ� ��༭ 1���� ����<br>&nbsp;&nbsp;&nbsp;������.<br>
		      			&nbsp;&nbsp;&nbsp;�� �뿩�̿���</span><br><br><br><br><br><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class=style5>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		      			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;		      			
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
    	<td><div align="right">(����ȣ <%=rent_s_cd%> : Page 2/2)&nbsp;</div>
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
