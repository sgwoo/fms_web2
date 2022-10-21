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

	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//차량기본정보
	ContCarBean car = a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//자동차기본정보
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//차량등록정보
	cr_bean = crd.getCarRegBean(base.getCar_mng_id());

	//차량정보
	Hashtable reserv = rs_db.getCarInfo(base.getCar_mng_id());
		
	//신차대여정보
	ContFeeBean f_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	//해당대여정보
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, rent_st);
	
	//자동이체정보
	ContCmsBean cms = a_db.getCmsMng(rent_mng_id, rent_l_cd);
	
	//보증보험
	//이행보증보험
	ContGiInsBean gins = a_db.getContGiInsNew(rent_mng_id, rent_l_cd, "1");
	int gin_size 	= a_db.getGinCnt(rent_mng_id, rent_l_cd);
	if(gin_size==0) gin_size = 1;
	ContGiInsBean ext_gin = new ContGiInsBean();
	for(int f=1; f<=gin_size ; f++){
		ext_gin = a_db.getContGiInsNew(rent_mng_id, rent_l_cd, Integer.toString(f));	
	}				
	
	//전계약매입옵션
	int fee_opt_amt = 0;
	if(rent_st.equals("2")){
		fee_opt_amt = f_fee.getOpt_s_amt()+f_fee.getOpt_v_amt();
	}else if(AddUtil.parseInt(rent_st) >2){
		ContFeeBean a_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, String.valueOf(AddUtil.parseInt(rent_st)-1));	
		fee_opt_amt = a_fee.getOpt_s_amt()+a_fee.getOpt_v_amt();
	}
	
	//차량기본정보
	ContCarBean f_fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1");

	//차량기본정보
	ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, rent_st);
	
	//월렌트정보
	ContFeeRmBean f_fee_rm = a_db.getContFeeRm(rent_mng_id, rent_l_cd, "1");

	//월렌트정보
	ContFeeRmBean fee_rm = a_db.getContFeeRm(rent_mng_id, rent_l_cd, rent_st);
				
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//지점정보
	ClientSiteBean site = al_db.getClientSite(base.getClient_id(), base.getR_site());
	
	//법인고객차량관리자
	Vector car_mgrs = a_db.getCarMgrListNew(rent_mng_id, rent_l_cd, "Y");
	int mgr_size = car_mgrs.size();
	
	CarMgrBean mgr1 = new CarMgrBean();
	CarMgrBean mgr2 = new CarMgrBean();
	CarMgrBean mgr3 = new CarMgrBean();
	
	for(int i = 0 ; i < mgr_size ; i++){
        	CarMgrBean mgr = (CarMgrBean)car_mgrs.elementAt(i);
        	if(mgr.getMgr_st().equals("차량이용자")){
        		mgr1 = mgr;
        	}
        	if(mgr.getMgr_st().equals("추가운전자")){
        		mgr2 = mgr;
        	}
        	if(mgr.getMgr_st().equals("대리인")){
        		mgr3 = mgr;
        	}
	}        					
	
	//보험정보
	String ins_st = ai_db.getInsSt(base.getCar_mng_id());
	ins = ai_db.getIns(base.getCar_mng_id(), ins_st);
		
    	//담당자들
    	UsersBean user_bean1 	= umd.getUsersBean(base.getBus_id());
    	UsersBean user_bean2 	= umd.getUsersBean(base.getMng_id());

	if(!rent_st.equals("1"))	user_bean1 	= umd.getUsersBean(fee.getExt_agnt());

    	
    	UsersBean user_bean3 	= new UsersBean();
    	
    	if(user_bean1.getBr_id().equals("S1") || user_bean1.getBr_id().equals("S2") || user_bean1.getBr_id().equals("I1") || user_bean1.getBr_id().equals("K3")||user_bean1.getBr_id().equals("S3") || user_bean1.getBr_id().equals("S4")||user_bean1.getBr_id().equals("S5") || user_bean1.getBr_id().equals("S6"))	user_bean3 	= umd.getUsersBean(nm_db.getWorkAuthUser("본사월렌트담당"));
    	if(user_bean1.getBr_id().equals("B1") || user_bean1.getBr_id().equals("G1") || user_bean1.getBr_id().equals("U1"))						user_bean3 	= umd.getUsersBean("000053");
    	if(user_bean1.getBr_id().equals("D1") || user_bean1.getBr_id().equals("J1"))											user_bean3 	= umd.getUsersBean(base.getBus_id2());
    	
	user_bean3 	= umd.getUsersBean(base.getBus_id2());
	
	//견적정보
	EstimateBean e_bean = new EstimateBean();
	
	e_bean = e_db.getEstimateShCase(f_fee_rm.getEst_id());
	
	
	String end_dt7 = c_db.addDay(fee.getRent_end_dt(), -7); //7일전
	String end_dt5 = c_db.addDay(fee.getRent_end_dt(), -5); //5일전
	
	//20120830 월렌트홈페이지 적용	
	
	
	
	String per = "0";
	
		
	if(!f_fee_rm.getAmt_per().equals(""))	per = f_fee_rm.getAmt_per();
	
	
	//월대여료대부 적용율
	Hashtable day_pers = shDb.getEstiRmDayPers(per);
	
	int day_per[] = new int[30];

	//적용율값 카운트
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
<title>자동차대여이용계약서</title>
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
		<td><div align="center"><span class=style1>자 동 차 대 여 이 용 계 약 서<%if(!rent_st.equals("1")){%> (연장)<%}%></span></div></td>
	</tr>
	<tr>
		<td height=20></td>
	</tr>
  	<tr>
    	<td>
    		<table width="680" border="0" class="table_rmcar">
		      		<tr bgcolor="#FFFFFF" height="19">
			        	<td width="13%" bgcolor="e8e8e8"><div align="center">계약번호</div></td>
			        	<td width="16%" ><div align="left">&nbsp;<%=rent_l_cd%></div></td>
			        	<td width="12%" bgcolor="e8e8e8"><div align="center">영업소</div></td>
			        	<td width="12%"><div align="left">&nbsp;<%=c_db.getNameById(base.getBrch_id(),"BRCH")%></div></td>
			        	<td width="16%" bgcolor="e8e8e8"><div align="center">영업담당자</div></td>
			        	<td width="31%"><div align="left">&nbsp;<%=user_bean1.getUser_nm()%> <%=user_bean1.getUser_pos()%>
			        	    <%if(user_bean1.getLoan_st().equals("")){%><%=user_bean1.getHot_tel()%>
			        	    <%}else{%><%=user_bean1.getUser_m_tel()%><%}%>
			        	    </div></td>
			       	</tr>
				<tr bgcolor="#FFFFFF" height="35">
			        	<td bgcolor="e8e8e8"><div align="center">고객구분</div></td>
			        	<td><div align="left">&nbsp;<%if(client.getClient_st().equals("1")){ 		out.println("법인");
			        	}else if(client.getClient_st().equals("2")){  out.println("개인");
			        	}else if(client.getClient_st().equals("3")){ 	out.println("개인사업자(일반과세)");
			        	}else if(client.getClient_st().equals("4")){	out.println("개인사업자(간이과세)");
			        	}else if(client.getClient_st().equals("5")){ 	out.println("개인사업자(면세사업자)"); }%></div></td>
			        	<td bgcolor="e8e8e8"><div align="center">대여구분</div></td>
			        	<td><div align="left">&nbsp;월렌트</div></td>
                    			
			        	<td bgcolor="e8e8e8"><div align="center">관리담당자</div></td><!-- 2017. 10. 30 관리 담당자 수정 -->
			        	<td><div align="left">&nbsp;<%=user_bean2.getUser_nm()%> <%=user_bean2.getUser_pos()%>
			        	    <%if(user_bean2.getUser_nm().equals("계성진")){%>02-6263-6384
			        	    <%}else{%><%=user_bean2.getUser_m_tel()%><%}%>
			        	     <br>&nbsp;정비, 계약연장, 반납, 대여료관련
			        	   </div></td>
			        	    <!--
			        	    	<td><div align="left">&nbsp박영규 차장 042-824-1770 			      
			        	     <br>&nbsp;정비, 계약연장, 반납, 대여료관련
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
    		<td height=22px><div align="left"><img src=http://fms.amazoncar.co.kr/images/cardoc_arrow.gif> <span class=style2>고객사항</span></td>
    	</tr>
    	<tr>
    		<td>
      			<table width="680" border="0"  class="table_rmcar">
			        <tr bgcolor="#FFFFFF" height="19">
			          	<td width="13%"><div align="center">성명(대표자)</div></td>
			          	<td width="34%" colspan="2"><div align="left">&nbsp;<%=client.getClient_nm()%><%if(client.getClient_st().equals("1") && !client.getClient_nm().equals(mgr1.getMgr_nm()) && !client.getClient_nm().equals(mgr2.getMgr_nm())){%>&nbsp;&nbsp;&nbsp;&nbsp;(운전자 범위에서 제외됨)<%}%></div></td>
			          	<td width="18%"><div align="center"><%if(client.getClient_st().equals("1")){%>법인등록번호<%}else{%>생년월일<%}%></div></td>
			          	<td colspan="2"><div align="left">&nbsp;<%if(client.getClient_st().equals("1")){%><%=client.getSsn1()%>-<%=client.getSsn2()%><%}else{%><%=client.getSsn1()%><%}%></div></td>
			        </tr>
			        <tr bgcolor="#FFFFFF" height="19">
			          	<td><div align="center">상호</div></td>
			         	 <td colspan="2"><div align="left">&nbsp;<%=client.getFirm_nm()%></div></td>
			          	<td><div align="center">사업자등록번호</div></td>
			          	<td colspan="2"><div align="left">&nbsp;<%if(!client.getClient_st().equals("2")){%><%=client.getEnp_no1()%>-<%=client.getEnp_no2()%>-<%=client.getEnp_no3()%><%}%></div></td>
			        </tr>
			        <tr bgcolor="#FFFFFF" height="19">
			          	<td><div align="center">주소</div></td>
			          	<td colspan="5"><div align="left">&nbsp;<%=client.getO_addr()%></div></td>
			        </tr>
			        <tr bgcolor="#FFFFFF" height="19">
			          	<td><div align="center">운전면허번호</div></td>
			          	<td colspan="2"><div align="left">&nbsp;<%if(!client.getClient_st().equals("1")){%><%=base.getLic_no()%><%}%></div></td>
			         	<td rowspan="2"><div align="center">연락처</div></td>
			          	<td width="9%"><div align="center">전화번호 </div></td>
			          	<td width="26%"><div align="left">&nbsp;<%=AddUtil.phoneFormat(client.getO_tel())%></div></td>
			        </tr>
			        <tr bgcolor="#FFFFFF" height="19">
			          	<td><div align="center">비고</div></td>
			          	<td colspan="2"><div align="left">&nbsp;
			          		<!--
			          		          <%if(mgr1.getLic_st().equals("1")){%>2종보통<%}%>
	                        		<%if(mgr1.getLic_st().equals("2")){%>1종보통<%}%>
	                        		<%if(mgr1.getLic_st().equals("3")){%>1종대형<%}%>
	                  -->      		
	                        	</td>
			          	<td><div align="center">휴대폰</div></td>
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
			          	<td width="86" rowspan="4"><div align="center"><%if(!client.getClient_st().equals("1")){%>추가운전자<%}else{%>운전자<%}%></div></td>
			          	<td width="64"><div align="center">성명</div></td>
			         	<td width="161"><div align="left">&nbsp;<%if(!client.getClient_st().equals("1")){%><%=mgr2.getMgr_nm()%><%}else{%><%=mgr1.getMgr_nm()%><%}%></div></td>
			          	<td width="120"><div align="center">생년월일</div></td>
			          	<td width="235" colspan="2"><div align="left">&nbsp;<%if(!client.getClient_st().equals("1")){%><%=AddUtil.ChangeSsnBdt(mgr2.getSsn())%><%}else{%><%=AddUtil.ChangeSsnBdt(mgr1.getSsn())%><%}%></div></td>
			        </tr>
			        <tr bgcolor="#FFFFFF" height="20">
			          	<td><div align="center">주소</div></td>
			         	<td colspan="4"><div align="left">&nbsp;<%if(!client.getClient_st().equals("1")){%><%=mgr2.getMgr_addr()%><%}else{%><%=mgr1.getMgr_addr()%><%}%></div></td>
			        </tr>
			        <tr bgcolor="#FFFFFF" height="19">
			          	<td><div align="center">전화번호</div></td>
			          	<td><div align="left">&nbsp;<%if(!client.getClient_st().equals("1")){%><%=AddUtil.phoneFormat(mgr2.getMgr_m_tel())%><%if(mgr2.getMgr_m_tel().equals("")){%><%=AddUtil.phoneFormat(mgr2.getMgr_tel())%><%}%><%}else{%><%=AddUtil.phoneFormat(mgr1.getMgr_m_tel())%><%if(mgr1.getMgr_m_tel().equals("")){%><%=AddUtil.phoneFormat(mgr1.getMgr_tel())%><%}%><%}%></div></td>
			          	<td><div align="center">운전면허번호</div></td>
			          	<td colspan="2"><div align="left">&nbsp;<%if(!client.getClient_st().equals("1")){%><%=mgr2.getLic_no()%><%}else{%><%=mgr1.getLic_no()%><%}%></div></td>
			        </tr>
			        <tr bgcolor="#FFFFFF" height="19">
			          	<td><div align="center"><%if(!client.getClient_st().equals("1")){%>기타<%}else{%>추가운전자<%}%></div></td>
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
	    	<td height=22px><div align="left"><span class=style2><img src=http://fms.amazoncar.co.kr/images/cardoc_arrow.gif> 대여차량 및 이용기간</span></div></td>
	    </tr>
	    <tr>
			<td>
      		<table width="680" border="0" class="table_rmcar">
        		<tr bgcolor="e8e8e8" height="30">
		          	<td width="13%" ><div align="center">차명</div></td>
		          	<td colspan="4"><div align="left">&nbsp;<%=reserv.get("CAR_NM")%>&nbsp;<%=reserv.get("CAR_NAME")%></div></td>
		          	<td width="13%"><div align="center">차량번호</div></td>
		          	<td width="20%"><div align="left">&nbsp;<%=reserv.get("CAR_NO")%></div></td>
       		 	</tr>
        		<tr bgcolor="e8e8e8" height="19">
		          	<td><div align="center">연료종류</div></td>
		          	<td colspan="2"><div align="left">&nbsp;<%=reserv.get("FUEL_KD")%></div></td>
		          	<td width="13%"><div align="center">누적주행거리</div></td>
		          	<td width="20%"><div align="left">&nbsp;<%=AddUtil.parseDecimal(f_fee_etc.getSh_km())%>km</div></td>
		          	<td><div align="center">추가대여품목</div></td>
		          	<td><div align="left">&nbsp;<%if(f_fee_rm.getNavi_yn().equals("Y")){%>거치형내비게이션<%}%></div></td>
        		</tr>
        		<tr bgcolor="e8e8e8" height="19">
		          	<td rowspan="3"><div align="center">이용기간</div></td>
		          	<td width="9%"><div align="center">기간</div></td>
		          	<td colspan="2"><div align="left">&nbsp;<%=fee.getCon_mon()%>개월
		          	<%if(!fee_etc.getCon_day().equals("0") && !fee_etc.getCon_day().equals("")){%><%=fee_etc.getCon_day()%>일<%}%>
		          	</div></td>
		          	<td><div align="center">차량이용용도</div></td>
		          	<td colspan="2"><div align="left">&nbsp;<%=f_fee_rm.getCar_use()%></div></td>
		        </tr>
		        <tr bgcolor="e8e8e8" height="19">
		          	<td><div align="center">날짜</div></td>
		          	<td colspan="5"><div align="left">&nbsp;
		          	<%if(fee.getRent_start_dt().equals("")){%>
		          	<%=AddUtil.ChangeDate2(fee_rm.getDeli_plan_dt())%>  ~ <%=AddUtil.ChangeDate2(fee_rm.getRet_plan_dt())%>
		          	<%}else{%>
		          	<%=AddUtil.ChangeDate2(fee.getRent_start_dt())%>  ~ <%=AddUtil.ChangeDate2(fee.getRent_end_dt())%>
		          	<%}%>
		          	</div></td>
		        </tr>
		        <tr bgcolor="e8e8e8" height="19">
		          	<td colspan="6"><div align="left">&nbsp;대여요금은 월단위로 산정하며, 1개월 미만을 일자정산하여야 할 경우에는 30일을 1개월로 봅니다.</div></td>
		        </tr>
      		</table>
      	</td>
	</tr>
<!-- 	<tr> -->
<!--     	<td height=10></td> -->
<!--     </tr>		 -->
	<tr>
    	<td height=22px><div align="left"><span class=style2><img src=http://fms.amazoncar.co.kr/images/cardoc_arrow.gif> 배차/반차 예정사항</span></div></td>
    </tr>
    <%	//연장일때 반차셋팅
    		if(!rent_st.equals("1")){
    			fee_rm.setDeli_plan_dt("-");
    			fee_rm.setDeli_loc("-");
    			fee_rm.setRet_plan_dt(fee.getRent_end_dt());
    			fee_rm.setRet_loc(f_fee_rm.getRet_loc());
    		}
    		
    		String retPlanDt = fee_rm.getRet_plan_dt().substring(0,8);	// 반차일 YYYYMMDD
    		String retPlanDate = AddUtil.getDateDay(retPlanDt);	// 반차 요일
    		String retPlanTime = "(오전 9시~오후 5시)";
    		if(retPlanDate.equals("일")){		// 일요일
    			retPlanDt = String.valueOf(Integer.parseInt(retPlanDt) + 1);
    		} else if(retPlanDate.equals("토")){	// 토요일
    			retPlanTime = "(오전 9~12시)";
    		}
    %>
	<tr>
		<td>
      		<table width="680" border="0" class="table_rmcar">
		        <tr bgcolor="#FFFFFF" height="19">
		          	<td width="13%" rowspan="2" bgcolor="e8e8e8"><div align="center">배/반차시간<br>및 장소</div></td>
		        	<td width="7%"><div align="center">배차</div></td>
		          	<td width="25%"><div align="left">&nbsp;<%=AddUtil.getDate3(fee_rm.getDeli_plan_dt())%></div></td>
		          	<td width="7%"><div align="center">반차</div></td>
<%-- 		        	<td width="45%"><div align="left">&nbsp;<%=AddUtil.getDate3(fee_rm.getRet_plan_dt())%></div></td> --%>
		        	<td width="45%">
		        		<div align="left">
		        			&nbsp;<span style="font-weight: bold;"><%=AddUtil.getDate3(retPlanDt)%> <%=retPlanTime%></span>
		        			<br>※ 단, 공휴일 및 토요일은 오전 9~12시까지 반납 가능
		        			<br>※ 단, 일요일, 설날(음력1월1일) 및 추석당일 반납불가 (익일반납)
		        		</div>
		        	</td>
		        </tr>
		        <tr bgcolor="#FFFFFF" height="19">
		          	<td><div align="center">장소</div></td>
		          	<td><div align="left">&nbsp;<%=fee_rm.getDeli_loc()%></div></td>
		          	<td><div align="center">장소</div></td>
		          	<td><div align="left">&nbsp;<%=fee_rm.getRet_loc()%>
		          	<%	//연장일때 반차셋팅
    								if(!rent_st.equals("1")){
    									fee_rm.setDeli_loc(f_fee_rm.getDeli_loc());
    								}
    						%>	
		          	<%if(fee_rm.getDeli_loc().equals("영남주차장")){%>
		          	(TEL.02-6263-6378)<br> &nbsp;서울 영등포구 영등포로 34길 9
		          	<%}else if(fee_rm.getDeli_loc().equals("대전지점 주차장")){%>		          	
		          	(TEL.042-824-1770)<br> &nbsp;대전 대덕구 벚꽃길100, 현대카독크
		          	<%}else if(fee_rm.getDeli_loc().equals("부산지점 주차장")){%>
		          	(TEL.051-851-0606)<br> &nbsp;부산 연제구 거제천로 270번길 5, 부경자동차정비
		          	<%}else if(fee_rm.getDeli_loc().equals("광주지점 주차장")){%>
		          	(TEL.062-385-0133)<br> &nbsp;광주 서구 상무누리로 131-1, 상무1급자동차공업사
		          	<%}else if(fee_rm.getDeli_loc().equals("대구지점 주차장")){%>
		          	(TEL.053-582-2998)<br> &nbsp;대구 달서구 달서대로 109길 58, 성서현대정비센터
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
    	<td height=22px><div align="left"><span class=style2><img src=http://fms.amazoncar.co.kr/images/cardoc_arrow.gif> 대여요금</span></div></td>
    </tr>
	<tr>
		<td>
      		<table width="680" border="0" class="table_rmcar">
		        <tr>
		          	<td  width="13%" rowspan="2"  bgcolor="e8e8e8"><div align="center">구분</div></td>
		          	<td colspan="4" bgcolor="e8e8e8" height="19"><div align="center">월대여료</div></td>
		          	<td width="15%" rowspan="2" bgcolor="e8e8e8"><div align="center">배/반차료</div></td>
		          	<td width="15%" rowspan="2" bgcolor="e8e8e8"><div align="center">합계</div></td>
		        </tr>
		        <tr>
		          	<td height="21" width="14%" bgcolor="e8e8e8"><div align="center">차량</div></td>
		          	<td width="14%" bgcolor="e8e8e8"><div align="center">내비게이션</div></td>
		        	<td width="14%" bgcolor="e8e8e8"><div align="center">기타</div></td>
		          	<td width="14%" bgcolor="e8e8e8"><div align="center">합계</div></td>
		        </tr>
		        <tr>
		          	<td height="21" bgcolor="e8e8e8"><div align="center">공급가</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(fee.getInv_s_amt()-fee_rm.getDc_s_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(fee_rm.getNavi_s_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(fee_rm.getEtc_s_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(fee.getFee_s_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(fee_rm.getCons1_s_amt()+fee_rm.getCons2_s_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(fee_rm.getT_fee_s_amt()+fee_rm.getCons1_s_amt()+fee_rm.getCons2_s_amt())%>&nbsp;</div></td>
		        </tr>
		        <tr>
		          	<td height="21" bgcolor="e8e8e8"><div align="center">부가세</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(fee.getInv_v_amt()-fee_rm.getDc_v_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(fee_rm.getNavi_v_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(fee_rm.getEtc_v_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(fee.getFee_v_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(fee_rm.getCons1_v_amt()+fee_rm.getCons2_v_amt())%>&nbsp;</div></td>
		        	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(fee_rm.getT_fee_v_amt()+fee_rm.getCons1_v_amt()+fee_rm.getCons2_v_amt())%>&nbsp;</div></td>
		        </tr>
		        <tr>
		          	<td height="21" bgcolor="e8e8e8"><div align="center">합계</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(fee.getInv_s_amt()-fee_rm.getDc_s_amt()+fee.getInv_v_amt()-fee_rm.getDc_v_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(fee_rm.getNavi_s_amt()+fee_rm.getNavi_v_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(fee_rm.getEtc_s_amt()+fee_rm.getEtc_v_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(fee.getFee_s_amt()+fee.getFee_v_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(fee_rm.getCons1_s_amt()+fee_rm.getCons1_v_amt()+fee_rm.getCons2_s_amt()+fee_rm.getCons2_v_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(fee_rm.getT_fee_s_amt()+fee_rm.getT_fee_v_amt()+fee_rm.getCons1_s_amt()+fee_rm.getCons1_v_amt()+fee_rm.getCons2_s_amt()+fee_rm.getCons2_v_amt())%>&nbsp;</div></td>
		        </tr>
		        <tr>
		          	<td height="21" bgcolor="e8e8e8" ><div align="center">결제방법</div></td>
		          	<td colspan="6" bgcolor="e8e8e8" >
		          		<table width=100% border=0 cellspacing=0 cellpadding=0>
		          			<tr>
		          				<td style="border:0px;"><div align="left">&nbsp;<%if(fee_rm.getF_paid_way().equals("1")){%>1개월치씩<%}%> <%if(fee_rm.getF_paid_way().equals("2")){%>대여료 전액 <%}%>
		          	  			<%if(fee.getFee_sh().equals("1")){%>선불<%}%><%if(fee.getFee_sh().equals("0")){%>후불<%}%>
		          	  			</div></td>
		          	  			<td style="border:0px;"> <div align="right">배/반차료는 선불입니다&nbsp;</div></td>
		          	  		</tr>
		          	  	</table>
		          	</td>
		        </tr>
		        <%if(rent_st.equals("1")){%>
		        <tr>
		        	<td height="21" bgcolor="e8e8e8"><div align="center">최초결제금액</div></td>
		        	<td colspan="6" bgcolor="e8e8e8"><div align="left">&nbsp;<%=AddUtil.parseDecimal(fee_rm.getF_rent_tot_amt())%>원, 
		        	<%if(fee_rm.getF_paid_way().equals("1")){%>첫회차 대여료<%}%>
		        	<%if(fee_rm.getF_paid_way().equals("2")){%>대여료 총액<%}%>
		        	<%if(fee_rm.getCons1_s_amt()>0){%>+ 배/반차료<%}%>
		        	</div></td>
		        </tr>
		        <%}%>
		        <tr>
		        	<td rowspan=2 bgcolor="e8e8e8"><div align="center">비고</div></td>
		        	<td colspan="6" bgcolor="e8e8e8" height="50"><div align="left">&nbsp;<%=fee.getFee_cdt()%></div></td>
		        </tr>
		        <tr>
		          	<td colspan="7" bgcolor="e8e8e8" height="40"><div align="left">&nbsp;2회차부터의 대여요금은 해당 회차 대여시작일 하루전 날이 대여요금 결제일이 됩니다.</div></td>
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
          			<td width="13%" rowspan=2 bgcolor="e8e8e8"><div align="center">자동이체<br>신청</div></td>
          			<td height="42" align=center>자동이체<br>방법</td>
          			<td height="40"><div align="center">
          				<table width="100%" border="0" cellpadding="0" cellspacing="1">
          					<tr>
          						<td style="border:0px;"><div align="center"><input type="checkbox" name="checkbox" value="checkbox" <%if(f_fee_rm.getCms_type().equals("card")){%>checked<%}%>> 신용카드 자동출금</div></td>
          						<td style="border:0px;"><div align="center"><input type="checkbox" name="checkbox" value="checkbox" <%if(f_fee_rm.getCms_type().equals("cms")||fee_rm.getCms_type().equals("")){%>checked<%}%>> CMS 자동이체</div></td>
          					</tr>
          					<tr>
          						<td style="border:0px;"><div align="center">(별지의 신용카드 자동출금 이용신청서 작성)</div></td>
          						<td style="border:0px;"><div align="center">(별지 CMS 출금이체 신청서 작성)</div></td>
          					</tr>
          				</table>
          				</div></td>
        		</tr>
        		<tr bgcolor="#FFFFFF" height="40">
        			<td height="42" align=center>자동이체<br>대상</td>
        			<td><div align="left"> &nbsp;2회차부터의 대여요금, 연장대여요금, 연체이자, 중도해지정산금, 면책금, 과태료, 초과운행대여료</div></td>
        		</tr>
        	</table>
        </td>
    </tr>
	<tr>
    	<td height=5></td>
    </tr>
    <tr>
    	<td><div align="right">(계약번호 <%=rent_l_cd%> : Page 1/2)&nbsp;</div>
    </tr>
</table>

<h1 style="margin-top: 8px;">
<table width="680" border="0" cellspacing="0" cellpadding="0">
	<tr>
    	<td height=22px><div align="left"><span class=style2><img src=http://fms.amazoncar.co.kr/images/cardoc_arrow.gif> 보험사항 및 고객책임사항</span>&nbsp;
    	        (
    		<%if(ins.getIns_com_id().equals("0007")){%>		삼성화재 사고접수 1588-5114, 
    		<%}else if(ins.getIns_com_id().equals("0008")){%>	동부화재 사고접수 1588-0100, 
    		<%}else if(ins.getIns_com_id().equals("0038")){%>	렌터카공제조합 사고접수 1661-7977, 
    		<%}%>
    		긴급출동 마스타자동차관리 1588-6688     		
    		)    		
    	    </div>
    	</td>
    </tr>
	<tr>
		<td>
      		<table width="680" border="0" class="table_rmcar">
        		<tr bgcolor="e8e8e8">
          			<td width="33%" style="padding: 0; height: 17px;"><div align="center"><span class=style4>운전자연령</span></div></td>
          			<td colspan="2" style="padding: 0; height: 17px;"><div align="center"><span class=style4>보험가입내역(보상한도)</span></div></td>
          			<td colspan="2" style="padding: 0; height: 17px;"><div align="center"><span class=style4>자기차량손해 사고시</span></div></td>
        		</tr>
        		<tr bgcolor="#FFFFFF">
          			<td width="33%" rowspan="4" style="padding: 0;">
          				<table width="100%" border=0 cellspacing=0 cellpadding=0 class="table_n">
          					<tr>
          						<td><div align="center"><span class=style4>만26세 이상</span></div></td>
          					</tr>
          					<tr bgcolor="e8e8e8" style="border-top: 1px solid #949494; border-bottom: 1px solid #949494;">
          						<td style="height: 20;"><div align="center"><span class=style4>운전자범위</span></div></td>
          					</tr>
          					<tr>
          						<td>
          							<div align="left">
          								<span class=style4>
          									(1)계약자<br>
          									(2)계약서상 명시된 추가운전자<br>
          									※ 계약자가 법인 및 개인사업자인 경우에는 임직원만 운전 가능(임직원 한정운전 특약 가입. 단, 경차 및 9인승차량은 특약 미가입)
          								</span>
          							</div>
          						</td>
          					</tr>
          				</table>
          			</td>
          			<td width="10%" bgcolor="e8e8e8" height="30"><div align="center"><span class="style8">대인배상</span></div></td>
          			<td width="13%" bgcolor="e8e8e8"><div align="center"><span class="style8">무한<br>(대인배상Ⅰ,Ⅱ)</span></div></td>
          			<td width="32%" rowspan="4" valign=top>
          				<table width=100% border=0 cellspacing=0 cellpadding=0 class="table_n">
							<tr>
								<td style="height:3px;"></td>
							</tr>
          					<tr>
          						<td style="padding:7px;">&nbsp; <span class=style4>선택1. 자기차량손해 면책금(사고 건당)<br>
			          			&nbsp;&nbsp;&nbsp; <input type="checkbox" name="checkbox" value="checkbox" <%if(base.getCar_ja()==300000)%>checked<%%>> 30만원 / <input type="checkbox" name="checkbox" value="checkbox" <%if(!String.valueOf(base.getCar_ja()).equals("300000"))%>checked<%%>> 기타(<%if(!String.valueOf(base.getCar_ja()).equals("300000") && base.getCar_ja()>=100000){%><%=base.getCar_ja()/10000%><%}else{%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%}%>)만원</span><br>
			      				<span class=style3>(별도의 당사 차량손해면책제도에 의거 보상-좌측의 종합보험 가입보험사 약관에 준함. 단,도난사고 발생시에는 차량잔존가치[=신차가격×(1-(차령개월수×0.01))]의 20% 금액은 고객이 부담함.)</span></td>
			      			</tr>
			      		</table>
			      	</td>
          			<td width="12%" rowspan="4" valign=top>
          				<table width=100% border=0 cellspacing=0 cellpadding=0 class="table_n">
          					<tr>
								<td style="height:10px;"></td>
							</tr>
          					<tr>
          						<td><div align="left">&nbsp; <span class=style3>선택2.<br> &nbsp;&nbsp;수리기간 동안<br>
          							&nbsp; 의 휴차보상료<br>&nbsp; <input type="checkbox" name="checkbox" value="checkbox" <%if(f_fee_rm.getMy_accid_yn().equals("Y")||f_fee_rm.getMy_accid_yn().equals("")){%>checked<%}%>> 고객부담<br>&nbsp; <input type="checkbox" name="checkbox" value="checkbox" <%if(f_fee_rm.getMy_accid_yn().equals("N")){%>checked<%}%>> 면제</span></div></td>
          					</tr>
          				</table>
          			</td>
        		</tr>
        		<tr bgcolor="e8e8e8">
          			<td height="20"><div align="center"><span class="style8">대물배상</span></div></td>
          			<td><div align="center"><span class="style8">1억원</span></div></td>
        		</tr>
        		<tr bgcolor="e8e8e8">
          			<td height="30"><div align="center"><span class="style8">자기신체사고</span></div></td>
          			<td><div align="center"><span class="style8">사망/장해 1억원<br>부상 1500만원</span></div></td>
        		</tr>
        		<tr bgcolor="e8e8e8">
         	 		<td height="22"><div align="center"><span class="style8">무보험차상해</span></div></td>
          			<td><div align="center"><span class="style8">2억원</span></div></td>
        		</tr>
        		<tr bgcolor="#FFFFFF">
          			<td height="34" colspan="6" style="padding:5px;"><div align="left"><span style="font-size: 11px;">※ 휴차보상 : 고객의 귀책사유에 의한 사고 발생시, 대여차량의 수리기간에 해당하는 대여요금(아마존카 단기렌트 요금표 기준)의 50%를 고객이 부담하셔야 합니다. (자동차대여 표준약관 제19조에 의함)</span></div></td>
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
		          	<td rowspan="3" width="13%"><div align="center">아마존카<br>단기렌트<br>요금</div></td>
		          	<td><div align="center">대여차량</div></td>
		          	<td colspan="4"><div align="center">대여기간별 1일 요금 (부가세 포함)</div></td>
		        </tr>
		        <tr bgcolor="#FFFFFF" height="20">
		          	<td rowspan="2"><div align="center"><%=f_fee_rm.getCars()%></div></td>
		          	<td width="12%"><div align="center">1~2일</div></td>
		          	<td width="12%"><div align="center">3~4일</div></td>
		          	<td width="12%"><div align="center">5~6일</div></td>
		          	<td width="12%"><div align="center">7일이상</div></td>
		        </tr>
		        <tr bgcolor="#FFFFFF" height="22">
		          	<td><div align="center"><%=AddUtil.parseDecimal(f_fee_rm.getAmt_01d()*1.1)%>원</div></td>
		          	<td><div align="center"><%=AddUtil.parseDecimal(f_fee_rm.getAmt_03d()*1.1)%>원</div></td>
		          	<td><div align="center"><%=AddUtil.parseDecimal(f_fee_rm.getAmt_05d()*1.1)%>원</div></td>
		          	<td><div align="center"><%=AddUtil.parseDecimal(f_fee_rm.getAmt_07d()*1.1)%>원</div></td>
		        </tr>
			</table>
		</td>
	</tr>
<!-- 	<tr> -->
<!--     	<td height=10></td> -->
<!--     </tr>	 -->
	<tr>
    	<td height=22px><div align="left"><span class=style2><img src=http://fms.amazoncar.co.kr/images/cardoc_arrow.gif> 기타계약조건</span></div></td>
    </tr>
	<tr>
		<td>
      		<table width="680" border="0" class="table_rmcar">
		        <tr bgcolor="#FFFFFF" height="35">
		          	<td bgcolor="e8e8e8"><div align="center">약정<br>운행거리</div></td>
		          	<td><div align="left">&nbsp;<%=AddUtil.parseDecimal(f_fee_etc.getAgree_dist())%>km / 1개월, 초과시 1km당 <%=AddUtil.parseDecimal(f_fee_etc.getOver_run_amt())%>원[부가세별도]의 초과운행대여료가 부과됩니다(대여종료시)</div></td>
		        </tr>
		        <tr bgcolor="e8e8e8" height="35">
		          	<td><div align="center">유류대<br>정산</div></td>
		          	<td bgcolor="e8e8e8"><div align="left">&nbsp;<span class=style6>본 계약은 월렌트(장기계약)의 특성상 유류대 정산을 하지 않습니다.<br>
		      			&nbsp;이용자께서는 이점을 감안하시어 이용하시기 바랍니다.</span></div></td>
		        </tr>
		        <tr bgcolor="#FFFFFF" height="65">
		          	<td bgcolor="e8e8e8">
		          		<div align="center" style="line-height: 20px;letter-spacing: -1px;">과태료<br>차량정비<br>사고발생시</div>
		          	</td>
		          	<td><div align="left"><span class=style4>&nbsp;1) 차량의 임차기간 중 발생되는 주정차 위반 및 교통법규 위반 과태료와 범칙금 등은 고객이 부담하여야 합니다.<br>
		      			&nbsp;2) 차량 이용 중 정비(고장수리, 엔진오일 교환 등)가 필요한 경우 필히 아마존카 관리담당자에게 연락하여야 하며,<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		      			 차량 정비시 아마존카 지정정비업체로 직접 방문해 주셔야 합니다. 정비비는 아마존카에서 지불하며,<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 개인비용으로 처리시 비용처리가 안됩니다.<br>
		      			&nbsp;3) 차량 이용 중 사고가 발생했을 경우 필히 아마존카 관리담당자에게 연락하여야 합니다.</span></div></td>
		        </tr>
		        <tr bgcolor="#FFFFFF" height="140">
		          	<td bgcolor="e8e8e8"><div align="center">계약 연장</div></td>
		          	<td><div align="left"><span class=style6>&nbsp;1) 연장계약은 임차인이 유선상으로 계약기간 연장 의사를 표시하고 아마존카가 승인한 후 연장대여료가 <br>
		          		&nbsp;&nbsp;&nbsp;&nbsp; 결제되면 확정됩니다.</span><br>
						&nbsp;<span class=style4>2) 임차인은 계약연장을 희망할 경우</span> <span class=style2>계약만료 7일전(<%=AddUtil.ChangeDate2(end_dt7)%>)까지</span> <span class=style4>아마존카로 연락을 주셔야 합니다.<br>
		      			&nbsp;3) 연장대여요금은 연장대여시작일 하루전에 신용카드 자동출금 또는 CMS 자동이체로 아마존카가 출금합니다.<br>
		      			&nbsp;&nbsp;&nbsp;&nbsp; 연장 대여시작일 하루전까지 대여요금이 결제되지 않으면 계약연장이 인정되지 않습니다.<br>
		      			&nbsp;4) 월단위 연장계약을 해야 연장기간 만료시 추가 연장 요청이 가능합니다.</span> <br>
		      			&nbsp;5) 일자단위로 연장계약시 전월 대여료 기준으로 일할계산하여 적용되며,연장기간 만료시 추가연장이 불가능합니다.<br>
		      			&nbsp;<span class=style6>※ 계약연장 희망시 고객님께서 먼저 아마존카로 연락하셔야 하며, 고객님의 연락이 없으면 연장하지 <br>
		      			&nbsp;&nbsp;&nbsp;&nbsp; 않는 것으로 간주합니다.(아마존카 계약연장담당자 : <%=user_bean2.getUser_nm()%> <%=user_bean2.getUser_pos()%>
		      			    <%if(user_bean2.getUser_nm().equals("계성진")){%>02-6263-6384
			        	    <%}else{%><%=user_bean2.getUser_m_tel()%><%}%>)</span></span></div></td><!-- 2017. 10. 30 관리 담당자 수정 -->
		        </tr>
		        <tr bgcolor="e8e8e8" height="35">
		          	<td><div align="center">대여료<br>연체시</div></td>
		          	<td bgcolor="e8e8e8"><div align="left"><span class=style4>&nbsp;1) 대여료 연체시에는 임대인은 즉시 계약을 해지할 수 있으며, 이 때 임차인은 차량을 즉시 반납하여야 합니다.<br>
 	      			&nbsp;2) 대여료 연체시 년리 24%의 연체이자가 부과됩니다.</span></div></td>
		        </tr>
		        <tr bgcolor="e8e8e8" height="35">
		          	<td><div align="center">중도해지시</div></td>
		          	<td bgcolor="e8e8e8"><div align="left"><span class=style4>&nbsp;1) 실이용기간이 <%if(day_cnt==30){%>1개월<%}else{%><%=day_cnt%>일<%}%> 이상일 경우 : 잔여기간 대여요금의 10%의 위약금이 부과됩니다.<br>
		      			&nbsp;2) 실이용기간이 <%if(day_cnt==30){%>1개월<%}else{%><%=day_cnt%>일<%}%> 미만일 경우 : 아래 명시된 요금정산 방법을 따릅니다.</span></div></td>
		        </tr>
		        <tr bgcolor="#FFFFFF">
		          	<td height="35" bgcolor="e8e8e8"><div align="center">기타<br>특이사항</div></td>
		          	<td><div align="left">&nbsp;<%=fee_etc.getCon_etc()%>
		          	<%if(AddUtil.parseInt(base.getRent_dt()) > 20160331 && client.getClient_st().equals("1") && AddUtil.parseInt(cm_bean.getS_st())>101 && AddUtil.parseInt(cm_bean.getS_st()) < 600 && AddUtil.parseInt(cm_bean.getS_st()) != 409){%>	
		          	※ 계약서상 운전자로 기재된 사람(임차 법인의 직원)만 운전가능합니다.
		          	<%}%>		          	
		          	</div></td>
		        </tr>
      		</table>
		</td>
	</tr>   
	<tr>
		<td><div align="left">&nbsp;<span class=style4>※ 본 계약서에 기재되지 않은 사항은 "자동차 대여 표준약관"에 의합니다. (아마존카 월렌트 전용 홈페이지 참조)</span></div></td>
<!-- 	<tr> -->
<!--     	<td height=10></td> -->
<!--     </tr> -->
	<tr>
    	<td height=22px><div align="left"><span class=style2><img src=http://fms.amazoncar.co.kr/images/cardoc_arrow.gif> 실이용기간이 <%if(day_cnt==30){%>1개월<%}else{%><%=day_cnt%>일<%}%> 미만일 경우의 요금정산</span> <span class=style4>(아래 기준에 의거 이용일 수 만큼의 대여료가 적용됩니다.)
    	&nbsp;&nbsp;<span class=style3>※ 기준:일, %</span></div></td>
    </tr>
	<tr>
		<td>
      		<table width="680" border="0" class="table_rmcar">
        		<tr bgcolor="#E8E8E8">
		          	<td width="107" height="22"><div align="center"><span class=style3>이용일수</span></div></td>
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
		          	<td height="24" bgcolor="e8e8e8"><div align="center"><span class=style3>월대여료<br>대비적용율</span></div></td>
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
					<td height=24 bgcolor="#FFFFFF" colspan=4><div align="center"><span class=style6>계약일 &nbsp;&nbsp;: &nbsp;&nbsp;<%=AddUtil.getDate3(fee.getRent_dt())%></span></div></td>
				</tr>
		        <tr bgcolor="#FFFFFF">
		          	<td width="46%" height=90><div align="left">&nbsp;&nbsp;<span class=style6>대여제공자 (임대인)</span><br>&nbsp;&nbsp;<span class=style4>서울시 영등포구 의사당대로 8, 802호(여의도동, 태흥빌딩)</span><br><br>
		      			&nbsp;&nbsp;<span class=style4>(주)아마존카 대표이사 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;조 &nbsp;&nbsp;&nbsp;성 &nbsp;&nbsp;&nbsp;희 &nbsp;(인)</span></div></td>
		          	<td colspan="3"><div align="left">&nbsp;&nbsp;&nbsp;<span class=style6>대여이용자 (임차인)</span><br>
		      			&nbsp;&nbsp;&nbsp;<span class=style4>본 계약의 내용을 확인하여 계약을 체결하고 계약서 1통을 정히 수령함.<br>
		      			&nbsp;&nbsp;&nbsp;위 대여이용자</span><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class=style5>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		      			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;		      			
		      			<span style="color:#000000;">(인)</span></span></div></td>
		        </tr>
		        
		        
		        <tr bgcolor="#FFFFFF">
		          	<td rowspan="3" style="padding:5px;"><div align="left"><span class=style3>본 대리인은 위 "자동차대여이용계약"에 대하여 그 내용을 숙지
		          	하고 임차인을 대리하여 (주)아마존카와 본 계약을 체결합니다.
				</span></div></td>
		          	<td width="9%" rowspan="3"><div align="center"><span class=style6>대리인</span></div></td>
		          	<td width="13%"  height="22"><div align="center">직 위</div></td>
		          	<td width="34%"><div align="left">&nbsp;<%if(client.getClient_st().equals("1")){%><%=mgr3.getEtc()%><%}%></div></td>
		        </tr>
		        <tr bgcolor="#FFFFFF">
		          	<td height="22"><div align="center">생년월일</div></td>
		          	<td><div align="left">&nbsp;<%if(client.getClient_st().equals("1")){%><%=mgr3.getSsn()%><%}%></div></td>
		        </tr>
		        <tr bgcolor="#FFFFFF">
		          	<td height="22"><div align="center">성 명</div></td>
		          	<td><div align="right"><%if(client.getClient_st().equals("1")){%><%=mgr3.getMgr_nm()%><%}%>(인)&nbsp;</div></td>
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
    				<td align=left>&nbsp;※아마존카 계좌:신한은행 140-004-023871 (주)아마존카</td>
    				<td align=right>(계약번호 <%=rent_l_cd%> : Page 2/2)&nbsp;</td>
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

factory.printing.header = ""; //폐이지상단 인쇄
factory.printing.footer = ""; //폐이지하단 인쇄
factory.printing.portrait = true; //true-세로인쇄, false-가로인쇄    
factory.printing.leftMargin = 9.0; //좌측여백   
factory.printing.topMargin = 10.0; //상단여백    
factory.printing.rightMargin = 9.0; //우측여백
factory.printing.bottomMargin = 8.0; //하단여백
factory.printing.Print(true, window);//arg1-대화상자표시여부(true or false), arg2-전체윈도우or특정프레임
}
</script>