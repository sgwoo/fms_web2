<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.res_search.*, acar.util.*, acar.car_service.*, acar.serv_off.*, acar.user_mng.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body>
<%
	String s_cd = request.getParameter("s_cd")==null?"":request.getParameter("s_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	Vector branches = c_db.getBranchList(); //영업소 리스트 조회
	int brch_size = branches.size();
	
	Vector users = c_db.getUserList("", "", "EMP"); //담당자 리스트
	int user_size = users.size();	

	//보험사 리스트
	InsComBean ic_r [] = c_db.getInsComAll();
	int ic_size = ic_r.length;	
	
	//차량정보
	Hashtable reserv = rs_db.getCarInfo(c_id);
	//단기계약정보
	RentContBean rc_bean = rs_db.getRentContCase(s_cd, c_id);
	//고객정보
	RentCustBean rc_bean2 = rs_db.getRentCustCase(rc_bean.getCust_st(), rc_bean.getCust_id());
	//단기관리자-연대보증인
	RentMgrBean rm_bean1 = rs_db.getRentMgrCase(s_cd, "1");
	RentMgrBean rm_bean2 = rs_db.getRentMgrCase(s_cd, "2");
	RentMgrBean rm_bean3 = rs_db.getRentMgrCase(s_cd, "3");
	
	//선수금정보
	ScdRentBean sr_bean1 = rs_db.getScdRentCase(s_cd, "1");
	ScdRentBean sr_bean2 = rs_db.getScdRentCase(s_cd, "2");
	String rent_st = rc_bean.getRent_st();
	String use_st = rc_bean.getUse_st();
	//연장계약
	Vector exts = rs_db.getRentContExtList(s_cd);
	int ext_size = exts.size();
	
%>
<form action="res_rent_u_a.jsp" name="form1" method="post" >

<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>예약시스템 > <span class=style5> <%if(rent_st.equals("1")){%>
                    단기대여 
                    <%}else if(rent_st.equals("2")){%>
                    정비대차 
                    <%}else if(rent_st.equals("3")){%>
                    사고대차 
                    <%}else if(rent_st.equals("9")){%>
                    보험대차 
                    <%}else if(rent_st.equals("10")){%>
                    지연대차 
                    <%}else if(rent_st.equals("4")){%>
                    업무대여 
                    <%}else if(rent_st.equals("5")){%>
                    업무지원 
                    <%}else if(rent_st.equals("6")){%>
                    차량정비 
                    <%}else if(rent_st.equals("7")){%>
                    차량점검 
                    <%}else if(rent_st.equals("8")){%>
                    사고수리 
                    <%}else if(rent_st.equals("11")){%>
                    장기대기 
                    <%}else if(rent_st.equals("12")){%>
                    월렌트
                    <%}%></span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>   
    <tr id=tr_cust_nm style="display:<%if(rent_st.equals("1")||rent_st.equals("2")||rent_st.equals("3")||rent_st.equals("4")||rent_st.equals("5")||rent_st.equals("9")||rent_st.equals("10")||rent_st.equals("11")||rent_st.equals("12")) {%>''<%}else{%>none<%}%>"> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>고객정보</span></td>
        <td align="right"> <a href='javascript:save();'> </a></td>
    </tr>
    <%if(rent_st.equals("1")||rent_st.equals("9")||rent_st.equals("12")){%>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title>구분</td>
                    <td>&nbsp;<%=rc_bean2.getCust_st()%></td>
                    <td class=title>성명</td>
                    <td colspan="3">&nbsp;<%=rc_bean2.getCust_nm()%></td>
                    <td class=title>생년월일</td>
                    <td>&nbsp;<%if(!nm_db.getWorkAuthUser("아마존카이외",ck_acar_id)){%><%=AddUtil.ChangeEnpH(rc_bean2.getSsn())%><%}%></td>
                </tr>
                <tr> 
                    <td class=title>상호</td>
                    <td colspan="5">&nbsp;<%=rc_bean2.getFirm_nm()%></td>
                    <td class=title>사업자등록번호</td>
                    <td>&nbsp;<%=rc_bean2.getEnp_no()%></td>
                </tr>
				<tr> 
                    <td class=title>사무실번호</td>
                    <td colspan="5">&nbsp;<%=rc_bean2.getTel()%></td>
                    <td class=title>휴대폰번호</td>
                    <td>&nbsp;<%=rc_bean2.getM_tel()%></td>
                </tr>
                <tr> 
                    <td class=title>주소</td>
                    <td colspan="7">&nbsp;<%=rc_bean2.getZip()%>&nbsp;<%=rc_bean2.getAddr()%> 
                    </td>
                </tr>
                <tr> 
                    <td class=title width=11%>운전면허번호</td>
                    <td width=16%>&nbsp;<%if(!nm_db.getWorkAuthUser("아마존카이외",ck_acar_id)){%><%=rc_bean2.getLic_no()%><%}%></td>
                    <td class=title width=10%>면허종류</td>
                    <td width=14%>&nbsp;<%=rc_bean2.getLic_st()%></td>
                    <td class=title width=10%>전화번호</td>
                    <td width=14%>&nbsp;<%=rc_bean2.getTel()%></td>
                    <td class=title width=12%>휴대폰</td>
                    <td width=13%>&nbsp;<%=rc_bean2.getM_tel()%></td>
                </tr>
                <tr> 
                    <td class=title>비상연락처</td>
                    <td  colspan='7'>&nbsp;성명:&nbsp;<%=rm_bean2.getMgr_nm()%> &nbsp;&nbsp; 
                      연락처:&nbsp;<%=rm_bean2.getTel()%> &nbsp; 관계:&nbsp;<%=rm_bean2.getEtc()%> 
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <%}else if(rent_st.equals("2") || rent_st.equals("3") || rent_st.equals("10") || rent_st.equals("11")){%>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=11%>구분</td>
                    <td width=22%>&nbsp;<%=rc_bean2.getCust_st()%></td>
                    <td class=title width=11%>성명</td>
                    <td width=22%>&nbsp;<%=rc_bean2.getCust_nm()%></td>
                    <td class=title width=12%>생년월일</td>
                    <td width=22%>&nbsp;<%if(!nm_db.getWorkAuthUser("아마존카이외",ck_acar_id)){%><%=AddUtil.ChangeEnpH(rc_bean2.getSsn())%><%}%></td>
                </tr>
                <tr> 
                    <td class=title>상호</td>
                    <td colspan="3">&nbsp;<%=rc_bean2.getFirm_nm()%></td>
                    <td class=title>사업자등록번호</td>
                    <td>&nbsp;<%=rc_bean2.getEnp_no()%></td>
                </tr>
				<tr> 
                    <td class=title>사무실번호</td>
                    <td colspan="3">&nbsp;<%=rc_bean2.getTel()%></td>
                    <td class=title>휴대폰번호</td>
                    <td>&nbsp;<%=rc_bean2.getM_tel()%></td>
                </tr>
				<tr> 
                    <td class=title>주소</td>
                    <td colspan="7">&nbsp;<%=rc_bean2.getZip()%>&nbsp;<%=rc_bean2.getAddr()%> 
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <%}else if(rent_st.equals("4") || rent_st.equals("5")){%>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=11%>구분</td>
                    <td width=15%>&nbsp;직원</td>
                    <td class=title width=10%>성명</td>
                    <td width=14%> 
                      &nbsp;<select name='c_cust_nm' onChange='javascript:user_select()' disabled>
                        <option value="">==선택==</option>
                        <%	if(user_size > 0){
        						for (int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i);	%>
                        <option value='<%=user.get("USER_ID")%>'  <%if(rc_bean2.getCust_id().equals(String.valueOf(user.get("USER_ID")))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                        <%		}
        					}		%>
                      </select>
                    </td>
                    <td class=title width=10%>영업소명</td>
                    <td width=15%>&nbsp;<%=rc_bean2.getBrch_nm()%></td>
                    <td class=title width=10%>부서명</td>
                    <td  width=15%>&nbsp;<%=rc_bean2.getDept_nm()%></td>
                </tr>
                <tr> 
                    <td class=title>운전면허번호</td>
                    <td>&nbsp;<%=rc_bean2.getLic_no()%></td>
                    <td class=title>면허종류</td>
                    <td>&nbsp;<%=rc_bean2.getLic_st()%></td>
                    <td class=title>전화번호</td>
                    <td>&nbsp;<%=rc_bean2.getTel()%></td>
                    <td class=title>휴대폰</td>
                    <td>&nbsp;<%=rc_bean2.getM_tel()%></td>
                </tr>
            </table>
        </td>
    </tr>

    <%}else{%>
    <%}%>
    <%if(rent_st.equals("2")){
		//정비대차정보
		Hashtable serv = rs_db.getInfoServ(rc_bean.getSub_c_id(), rc_bean.getServ_id());%>
    <tr><td class=h></td></tr>
	<tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>정비대차</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>           	
                <tr> 
                    <td class=title width=11%>정비공장명</td>
                    <td width=22%>&nbsp;<%=serv.get("OFF_NM")%></td>
                    <td class=title width=11%>정비차량번호</td>
                    <td width=22%>&nbsp;<%=serv.get("CAR_NO")%></td>
                    <td class=title width=11%>차종</td>
                    <td width=23%>&nbsp;<%=serv.get("CAR_NM")%></td>
                </tr>
            </table>
        </td>
    </tr>
    <%}else if(rent_st.equals("3")){
		//대차정보
		Hashtable accid = rs_db.getInfoAccid(rc_bean.getSub_c_id(), rc_bean.getAccid_id());%>
    <tr><td class=h></td></tr>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>사고대차</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=11%> 정비공장명</td>
                    <td width=22%>&nbsp;<%=accid.get("OFF_NM")%></td>
                    <td class=title width=11%>피해차량번호</td>
                    <td width=22%>&nbsp;<%=accid.get("CAR_NO")%></td>
                    <td class=title width=11%>차종</td>
                    <td width=23%>&nbsp;<%=accid.get("CAR_NM")%></td>
                </tr>
                <tr> 
                    <td class=title> 접수번호</td>
                    <td>&nbsp;<%=accid.get("P_NUM")%></td>
                    <td class=title>가해자보험사</td>
                    <td>&nbsp;<%=accid.get("G_INS")%></td>
                    <td class=title>담당자</td>
                    <td>&nbsp;<%=accid.get("G_INS_NM")%></td>
                </tr>
            </table>
        </td>
    </tr>
    <%}else if(rent_st.equals("9")){
		//보험대차정보
		RentInsBean ri_bean = rs_db.getRentInsCase(rc_bean.getSub_c_id());%>
    <tr><td class=h></td></tr>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>보험대차</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title> 접수번호</td>
                    <td>&nbsp;<%=ri_bean.getIns_num()%></td>
                    <td class=title>보험사</td>
                    <td colspan="5"> 
                      &nbsp;<select name='ins_com_id' disabled>
                        <%if(ic_size > 0){
        					for(int i = 0 ; i < ic_size ; i++){
        						InsComBean ic = ic_r[i];%>
                        <option value="<%=ic.getIns_com_id()%>" <%if(ri_bean.getIns_com_id().equals(ic.getIns_com_id()))%>selected<%%>><%=ic.getIns_com_nm()%></option>
                        <%	}
        				}%>
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td class=title width=10%> 담당자</td>
                    <td width=15%>&nbsp;<%=ri_bean.getIns_nm()%></td>
                    <td class=title width=10%>연락처Ⅰ</td>
                    <td width=15%>&nbsp;<%=ri_bean.getIns_tel()%></td>
                    <td class=title width=10%>연락처Ⅱ</td>
                    <td width=15%>&nbsp;<%=ri_bean.getIns_tel2()%></td>
                    <td class=title width=10%>팩스</td>
                    <td width=15%>&nbsp;<%=ri_bean.getIns_fax()%></td>
                </tr>
            </table>
        </td>
    </tr>
    <%}else if(rent_st.equals("6")){
		//차량정비정보
		Hashtable serv = rs_db.getInfoServ(c_id, rc_bean.getServ_id());%>
    <tr><td class=h></td></tr>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>차량정비</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=11%>정비공장명</td>
                    <td width=39%>&nbsp;<%=serv.get("OFF_NM")%></td>
                    <td class=title width=10%> 정비일자</td>
                    <td width=40%>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(serv.get("SERV_DT")))%></td>
                </tr>
            </table>
        </td>
    </tr>
    <%}else if(rent_st.equals("7")){
		//차량점검정보
		Hashtable maint = rs_db.getInfoMaint(c_id, rc_bean.getMaint_id());%>
    <tr><td class=h></td></tr>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>차량정검</span></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>검사유효기간</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("MAINT_ST_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("MAINT_END_DT")))%> 
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <%}else if(rent_st.equals("8")){
		//사고수리정보
		Hashtable accid = rs_db.getInfoAccid(c_id, rc_bean.getAccid_id());%>
    <tr><td class=h></td></tr>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>사고수리</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=11%>정비공장명</td>
                    <td width=22%>&nbsp;<%=accid.get("OFF_NM")%></td>
                    <td class=title width=11%>사고일자</td>
                    <td width=22%>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(accid.get("ACCID_DT")))%></td>
                    <td class=title width=11%>담당자</td>
                    <td width=23%>&nbsp;<%=c_db.getNameById(String.valueOf(accid.get("REG_ID")), "USER")%></td>
                </tr>
                <tr> 
                    <td class=title>사고내용</td>
                    <td colspan="5">&nbsp;<%=accid.get("ACCID_CONT")%>&nbsp;<%=accid.get("ACCID_CONT2")%></td>
                </tr>
            </table>
        </td>
    </tr>
    <%}%>
	<tr><td class=h></td></tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>계약정보</span></td>
        <td align="right"><font color="#999999"> 
        <%if(!rc_bean.getReg_id().equals("")){%>
        <img src=/acar/images/center/arrow_ccdrj.gif align=absmiddle> : <%=c_db.getNameById(rc_bean.getReg_id(), "USER")%>&nbsp;&nbsp; 
        <img src=/acar/images/center/arrow_ccdri.gif align=absmiddle> : <%=AddUtil.ChangeDate2(rc_bean.getReg_dt())%> 
        <%}%>
        <%if(!rc_bean.getUpdate_id().equals("")){%>
        &nbsp;&nbsp;<img src=/acar/images/center/arrow_cjsjj.gif align=absmiddle> : <%=c_db.getNameById(rc_bean.getUpdate_id(), "USER")%>&nbsp;&nbsp; 
        <img src=/acar/images/center/arrow_cjsji.gif align=absmiddle> : <%=AddUtil.ChangeDate2(rc_bean.getUpdate_dt())%> 
        <%}%>
        </font></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=11%>계약번호</td>
                    <td width=15%>&nbsp;<%=rc_bean.getRent_s_cd()%></td>
                    <td class=title width=10%>계약일자</td>
                    <td width=14%>&nbsp;<%=AddUtil.ChangeDate2(rc_bean.getRent_dt())%></td>
                    <td class=title width=10%>영업소</td>
                    <td width=15%> 
                      &nbsp;<select name='s_brch_id' disabled>
                        <option value=''>전체</option>
                        <%if(brch_size > 0){
        					for (int i = 0 ; i < brch_size ; i++){
        						Hashtable branch = (Hashtable)branches.elementAt(i);%>
                        <option value='<%= branch.get("BR_ID") %>' <%if(rc_bean.getBrch_id().equals(String.valueOf(branch.get("BR_ID")))){%>selected<%}%>><%= branch.get("BR_NM")%></option>
                        <%	}
        				}%>
                      </select>
                    </td>
                    <td width=10% class=title><%if(rent_st.equals("12")) {%>최초영업자 <%} else {%>담당자 <%}%></td>
                    <td width=15%> 
                      &nbsp;<%=c_db.getNameById(rc_bean.getBus_id(),"USER")%>
                    </td>
                </tr>
                <tr> 
                    <td class=title>이용기간</td>
                    <td colspan="5">&nbsp;<%=AddUtil.ChangeDate2(rc_bean.getRent_start_dt_d())%> 
                      <select name="rent_start_dt_h" onChange="getRentTime(); setDtHS(this);" disabled>
                        <%for(int i=0; i<25; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(rc_bean.getRent_start_dt_h().equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>시</option>
                        <%}%>
                      </select>
                      <select name="rent_start_dt_s" onChange="getRentTime(); setDtHS(this);" disabled>
                        <%for(int i=0; i<60; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(rc_bean.getRent_start_dt_s().equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>분</option>
                        <%}%>
                      </select>
                      ~ <%=AddUtil.ChangeDate2(rc_bean.getRent_end_dt_d())%> 
                      <select name="rent_end_dt_h" onChange="getRentTime(); setDtHS(this);" disabled>
                        <%for(int i=0; i<25; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(rc_bean.getRent_end_dt_h().equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>시</option>
                        <%}%>
                      </select>
                      <select name="rent_end_dt_s" onChange="getRentTime(); setDtHS(this);" disabled>
                        <%for(int i=0; i<60; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(rc_bean.getRent_end_dt_s().equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>분</option>
                        <%}%>
                      </select>
                      ( <%=rc_bean.getRent_hour()%>시간 <%=rc_bean.getRent_days()%>일 <%=rc_bean.getRent_months()%>개월 
                      ) </td>
                    <td width=10% class=title>관리담당자</td>
                    <td width=15%> 
                      &nbsp;<%=c_db.getNameById(rc_bean.getMng_id(),"USER")%>
                    </td>                      
                </tr>
    		  <%
    			if(ext_size > 0){
    				for(int i = 0 ; i < ext_size ; i++){
    					Hashtable ext = (Hashtable)exts.elementAt(i);%>		  
                <tr> 
                    <td class=title>연장 [<%=i+1%>]</td>
                    <td colspan="7">&nbsp; 
                        계약일자 : <%=AddUtil.ChangeDate2(String.valueOf(ext.get("RENT_DT")))%> &nbsp;&nbsp;
                        | 대여기간 : <%=AddUtil.ChangeDate2(String.valueOf(ext.get("RENT_START_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(ext.get("RENT_END_DT")))%> &nbsp;&nbsp;                    	
                        (<%=ext.get("RENT_MONTHS")%>개월<%=ext.get("RENT_DAYS")%>일)                   	
                    </td>
                </tr>
    		  <%		
    		  		}
    		  	}%> 	                
                <tr> 
                    <td class=title>기타 특이사항</td>
                    <td colspan="7">&nbsp;<%=rc_bean.getEtc()%></td>
                </tr>
            </table>
        </td>
    </tr>
	<tr><td class=h></td></tr>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>배차/반차</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=11%>배차예정일시</td>
                    <td width=39%>&nbsp;<%=AddUtil.ChangeDate2(rc_bean.getDeli_plan_dt_d())%> 
                      <select name="deli_plan_dt_h" disabled>
                        <%for(int i=0; i<25; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(rc_bean.getDeli_plan_dt_h().equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>시</option>
                        <%}%>
                      </select>
                      <select name="deli_plan_dt_s" disabled>
                        <%for(int i=0; i<60; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(rc_bean.getDeli_plan_dt_s().equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>분</option>
                        <%}%>
                      </select>
                    </td>
                    <td class=title width=10%>배차위치</td>
                    <td width=40%>&nbsp;<%=rc_bean.getDeli_loc()%></td>
                </tr>
                <%//if(!rent_st.equals("11")){%>
                <tr> 
                    <td class=title>배차일시</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(rc_bean.getDeli_dt_d())%> 
                      <select name="deli_dt_h" disabled>
                        <option value="">선택</option>
                        <%for(int i=0; i<25; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(rc_bean.getDeli_dt_h().equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>시</option>
                        <%}%>
                      </select>
                      <select name="deli_dt_s" disabled>
                        <option value="">선택</option>
                        <%for(int i=0; i<60; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(rc_bean.getDeli_dt_s().equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>분</option>
                        <%}%>
                      </select>
                    </td>
                    <td class=title>배차담당자</td>
                    <td> 
                      &nbsp;<select name='deli_mng_id' disabled>
                        <option value="">미지정</option>
                        <%if(user_size > 0){
        					for (int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i);	%>
                        <option value='<%=user.get("USER_ID")%>'  <%if(rc_bean.getDeli_mng_id().equals(String.valueOf(user.get("USER_ID")))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                        <%	}
        				}%>
                      </select>
                    </td>
                </tr>
              <%//}else{%>
    		  <!--
              <input type='hidden' name="deli_dt">
              <input type='hidden' name="deli_dt_h">
              <input type='hidden' name="deli_dt_s">
              <input type='hidden' name="deli_mng_id">-->
              <%//}%>
                <tr> 
                    <td class=title>반차예정일시</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(rc_bean.getRet_plan_dt_d())%> 
                      <select name="ret_plan_dt_h" disabled>
                        <%for(int i=0; i<25; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(rc_bean.getRet_plan_dt_h().equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>시</option>
                        <%}%>
                      </select>
                      <select name="ret_plan_dt_s" disabled>
                        <%for(int i=0; i<60; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(rc_bean.getRet_plan_dt_s().equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>분</option>
                        <%}%>
                      </select>
                    </td>
                    <td class=title>반차위치</td>
                    <td>&nbsp;<%=rc_bean.getRet_loc()%></td>
                </tr>
                <tr> 
                    <td class=title>반차일시</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(rc_bean.getRet_dt_d())%> 
                      <select name="ret_dt_h" disabled>
                        <option value="">선택</option>
                        <%for(int i=0; i<25; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(rc_bean.getRet_dt_h().equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>시</option>
                        <%}%>
                      </select>
                      <select name="ret_dt_s" disabled>
                        <option value="">선택</option>
                        <%for(int i=0; i<60; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(rc_bean.getRet_dt_s().equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>분</option>
                        <%}%>
                      </select>
                    </td>
                    <td class=title>반차담당자</td>
                    <td> 
                      &nbsp;<select name='ret_mng_id' disabled>
                        <option value="">미지정</option>
                        <%if(user_size > 0){
        					for (int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i);	%>
                        <option value='<%=user.get("USER_ID")%>'  <%if(rc_bean.getRet_mng_id().equals(String.valueOf(user.get("USER_ID")))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                        <%	}
        				}%>
                      </select>
                    </td>
                </tr>		  
            </table>
        </td>
    </tr>
    <tr align="right"> 
        <td colspan="2"><a href="javascript:window.close()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a></td>
    </tr>
</table>
</form>
</body>
</html>
