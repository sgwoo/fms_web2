<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.res_search.*, acar.util.*, acar.car_service.*, acar.serv_off.*, acar.accid.*, acar.cont.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String start_dt = request.getParameter("start_dt")==null?"":request.getParameter("start_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");		
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String code = request.getParameter("code")==null?"":request.getParameter("code");	
	String s_cc = request.getParameter("s_cc")==null?"":request.getParameter("s_cc");
	String s_year = request.getParameter("s_year")==null?"":request.getParameter("s_year");
	String s_kd = request.getParameter("s_kd")==null?"2":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"c.car_nm":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");
	
	String reg_dt = Util.getDate();
	
	//로그인ID&영업소ID&권한
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals(""))	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals("")) 	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "02", "05", "02");
	
	String s_cd = request.getParameter("s_cd")==null?"":request.getParameter("s_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	
	String sub_c_id = request.getParameter("sub_c_id")==null?"":request.getParameter("sub_c_id");
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");
	String seq_no = request.getParameter("seq_no")==null?"":request.getParameter("seq_no");
	
	String disabled = "disabled";
	String white = "white";
	String readonly = "readonly";
	if(mode.equals("u")){
		disabled = "";
		white = "";
		readonly = "";
	}
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	
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
	RentCustBean rc_bean3 = rs_db.getRentCustCase2(rc_bean.getCust_st(), rc_bean.getCust_id(), rc_bean.getRent_s_cd());
	//단기관리자-연대보증인
	RentMgrBean rm_bean1 = rs_db.getRentMgrCase(s_cd, "1");
	RentMgrBean rm_bean2 = rs_db.getRentMgrCase(s_cd, "2");
	RentMgrBean rm_bean3 = rs_db.getRentMgrCase(s_cd, "3");
	RentMgrBean rm_bean4 = rs_db.getRentMgrCase(s_cd, "4");
	
	//선수금정보
	ScdRentBean sr_bean1 = rs_db.getScdRentCase(s_cd, "1");
	ScdRentBean sr_bean2 = rs_db.getScdRentCase(s_cd, "2");
	String rent_st = rc_bean.getRent_st();
	String use_st = rc_bean.getUse_st();
	
	String print_car_no = "";
	String print_car_nm = "";
	
	AccidDatabase as_db = AccidDatabase.getInstance();
	MyAccidBean ma_bean = new MyAccidBean();
	if(mode.equals("accid_doc")){
		ma_bean = as_db.getMyAccid(sub_c_id, accid_id, AddUtil.parseInt(seq_no));
	}
	
	double img_width 	= 680;
	double img_height 	= 1009;
	
	String file_name4 ="";
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<style>

@page a4sheet { size: 21.0cm 29.7cm }



</style>
<script language='javascript'>
<!--
	function onprint(){
		factory.printing.header 	= ""; //폐이지상단 인쇄
		factory.printing.footer 	= ""; //폐이지하단 인쇄
		factory.printing.portrait 	= true; //true-세로인쇄, false-가로인쇄    
		factory.printing.leftMargin 	= 12.0; //좌측여백   
		factory.printing.rightMargin 	= 12.0; //우측여백
		factory.printing.topMargin 	= 15.0; //상단여백    
		factory.printing.bottomMargin 	= 15.0; //하단여백	
		factory.printing.Print(true, window);//arg1-대화상자표시여부(true or false), arg2-전체윈도우or특정프레임
	}
//-->
</script>
</head>
<%if(mode.equals("accid_doc")){%>
<body>
<%}else{%>
<body leftmargin="15" onLoad="javascript:onprint()" >
<object id="factory" style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,4,438,06"> 
</object> 
<%}%>

<form action="" name="form1" method="post" >
<input type='hidden' name='s_cd' value='<%=s_cd%>'>				
<table border=0 cellspacing=0 cellpadding=0 width=650>
    <tr colspan=2>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
				<td><center><font size="<%if(mode.equals("accid_doc")){%>4<%}else{%>6<%}%>" face="궁서체">>>
                    <%if(rent_st.equals("1")){%>
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
                    기타 
                    <%}else if(rent_st.equals("12")){%>
                    월렌트
                    <%}%>                     
                    <%if(!rent_st.equals("12")){%>
                    서비스 
                    <%}%>
                    계약서 <<
                </font>
                </center>
					</td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr> 
        <td align="right">&nbsp;</td>			
        <td align="right">&nbsp;</td>			
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>차량정보</span></td>
        <td align="right">&nbsp;</td>			
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                  <td width="15%" class=title>차량번호</td>
                  <td width="35%">&nbsp;<input name="car_no" type="text" class="whitetext" value="<%=reserv.get("CAR_NO")%>" size="15"></td>
                  <td width="15%" class=title>차명</td>
                  <td width="35%">&nbsp;<%=reserv.get("CAR_NM")%>&nbsp;<%=reserv.get("CAR_NAME")%> (<%=reserv.get("SECTION")%>)</td>
                </tr>
                <tr>
                  <td width="15%" class=title>최초등록일</td>
                  <td width="35%">&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("INIT_REG_DT")))%></td>
                  <td width="15%" class=title>차대번호</td>
                  <td width="35%">&nbsp;<%=reserv.get("CAR_NUM")%></td>
                </tr>
                <tr>
                  <td width="15%" class=title>출고일자</td>
                  <td width="35%">&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("DLV_DT")))%></td>
                  <td width="15%" class=title>배기량</td>
                  <td width="35%">&nbsp;<%=reserv.get("DPM")%>cc</td>
                </tr>
                <tr>
                  <td width="15%" class=title>칼라</td>
                  <td width="35%">&nbsp;<%=reserv.get("COLO")%></td>
                  <td width="15%" class=title>연료</td>
                  <td width="35%">&nbsp;<%=reserv.get("FUEL_KD")%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
    <tr id=tr_cust_nm style="display:<%if(rent_st.equals("1")||rent_st.equals("2")||rent_st.equals("3")||rent_st.equals("4")||rent_st.equals("5")||rent_st.equals("9")||rent_st.equals("10")||rent_st.equals("12")) {%>''<%}else{%>none<%}%>"> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>고객정보</span></td>
        <td align="right"><a href='javascript:save();'></a></td>
    </tr>
    <%if(rent_st.equals("1")||rent_st.equals("9")||rent_st.equals("12")){%>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                  <td width="15%" class=title>구분</td>
                  <td colspan="3">&nbsp;<%=rc_bean2.getCust_st()%> </td>
                </tr>
                <tr> 
                    <td width="15%" class=title>상호
        			</td>
                    <td width="35%">&nbsp; <%=rc_bean2.getFirm_nm()%>  
                    </td>
                    <td width="15%" class=title>성명</td>
                    <td width="35%">&nbsp;<%=rc_bean2.getCust_nm()%>                    </td>
                </tr>
                <tr> 
                    <td width="15%" class=title>사업자번호</td>
                    <td width="35%">&nbsp;<%=rc_bean2.getEnp_no()%> </td>
                    <td width="15%" class=title><%if(!rc_bean2.getCust_st().equals("법인")){%>생년월일 <%}else{%>법인번호 <%}%></td>
                    <td width="35%">&nbsp;<%=AddUtil.ChangeEnpH(rc_bean2.getSsn())%>                    </td>
                </tr>
                <tr> 
                    <td width="15%" class=title>주소</td>
                    <td colspan="3"> 
                        &nbsp;<%=rc_bean2.getZip()%>
                        &nbsp; 
                        <%=rc_bean2.getAddr()%>
                    </td>
                </tr>
                <tr> 
                    <td class=title width=15%>면허번호</td>
                    <td> 
                        &nbsp;<%=rm_bean4.getLic_no()%>
                    </td>
                    <td class=title>면허종류</td>
                    <td>&nbsp;<%if(rm_bean4.getLic_st().equals("1")){%>2종보통<%}%>
                        <%if(rm_bean4.getLic_st().equals("2")){%>1종보통<%}%>
                        <%if(rm_bean4.getLic_st().equals("3")){%>1종대형<%}%>                       
                    </td>
                </tr>
                <tr>
                  <td width="15%" class=title>전화번호</td>
                  <td>&nbsp;<%=rm_bean4.getTel()%> </td>
                  <td class=title>휴대폰</td>
                  <td>&nbsp;<%=rm_bean4.getEtc()%> </td>
                </tr>
            </table>
        </td>
    </tr>
    <%}else if(rent_st.equals("2") || rent_st.equals("3") || rent_st.equals("10")){%>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
              <tr>
                <td width="15%" class=title>구분</td>
                <td colspan="3">&nbsp;<%=rc_bean2.getCust_st()%> </td>
              </tr>
              <tr>
                <td width="15%" class=title>상호 </td>
                <td width="35%">&nbsp; <%=rc_bean2.getFirm_nm()%> </td>
                <td width="15%" class=title>성명</td>
                <td width="35%">&nbsp;<%=rc_bean2.getCust_nm()%> </td>
              </tr>
              <tr>
                <td width="15%" class=title>사업자번호</td>
                <td width="35%">&nbsp;<%=rc_bean2.getEnp_no()%> </td>
                <td width="15%" class=title><%if(!rc_bean2.getCust_st().equals("법인")) {%>
                  생년월일
                    <%}else{%>
                    법인번호
                    <%}%>
                </td>
                <td width="35%">&nbsp;<%=AddUtil.ChangeEnpH(rc_bean2.getSsn())%> </td>
              </tr>
              <tr>
                <td class=title>사업장주소</td>
                <td colspan="3">&nbsp;<%=rc_bean2.getZip()%> &nbsp; <%=rc_bean2.getAddr()%> </td>
              </tr>
              <tr>
                <td class=title>전화번호</td>
                <td>&nbsp;<%=rc_bean2.getTel()%> </td>
                <td class=title>휴대폰</td>
                <td>&nbsp;<%=rc_bean2.getM_tel()%> </td>
              </tr>
            </table></td>
    </tr>	
    <input type='hidden' name='c_zip' value=''>				
    <input type='hidden' name='c_addr' value=''>	
    <input type='hidden' name='c_lic_no' value=''>				
    <input type='hidden' name='c_lic_st' value=''>	
    <input type='hidden' name='c_tel' value=''>				
    <input type='hidden' name='c_m_tel' value=''>		
    <%}else if(rent_st.equals("4") || rent_st.equals("5")){%>
    <input type='hidden' name='c_firm_nm' value='(주)아마존카'>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=15%>구분</td>
                    <td width=35%> 
                        &nbsp;아마존카 직원
                    </td>
                    <td class=title width=15%>성명</td>
                    <td width=35%> 
                        &nbsp;<select name='c_cust_nm' onChange='javascript:user_select()' <%=disabled%>>
                            <option value="">==선택==</option>			  
                            <%	if(user_size > 0){
            						for (int i = 0 ; i < user_size ; i++){
            							Hashtable user = (Hashtable)users.elementAt(i);	%>
                            <option value='<%=user.get("USER_ID")%>'  <%if(rc_bean2.getCust_id().equals(String.valueOf(user.get("USER_ID")))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                            <%		}
            					}		%>
                        </select>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
	<%}else{%>
    <input type='hidden' name='c_cust_st' value='5'>	
    <input type='hidden' name='c_cust_nm' value=''>
    <input type='hidden' name='c_firm_nm' value=''>	
    <input type='hidden' name='c_ssn' value=''>
    <input type='hidden' name='c_enp_no' value=''>
    <input type='hidden' name='c_lic_no' value=''>				
    <input type='hidden' name='c_lic_st' value=''>
    <input type='hidden' name='c_zip' value=''>				
    <input type='hidden' name='c_addr' value=''>	
	<%}%>
    <tr><td class=h></td></tr>
	<%if(rent_st.equals("10")){
		//지연대차정보
		Hashtable serv = rs_db.getInfoTeacha2(rc_bean.getSub_l_cd(), String.valueOf(reserv.get("CAR_NO")));
		if(String.valueOf(serv.get("CAR_NM")).equals("null")){
			serv = rs_db.getInfoTeacha(rc_bean.getCust_id(), String.valueOf(reserv.get("CAR_NO")));
		}
		print_car_no = String.valueOf(serv.get("CAR_NO"))==null?"":String.valueOf(serv.get("CAR_NO"));
		print_car_nm = String.valueOf(serv.get("CAR_NM"))==null?"":String.valueOf(serv.get("CAR_NM"));
		
		if(print_car_no.equals("null")){ print_car_no="";}
		if(print_car_nm.equals("null")){ print_car_nm="";}
		
	%>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>지연대차</span></td>
    </tr>	
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100% >
                <tr>
                  <td width="15%" class=title style='height:38'>차량번호</td>
                  <td width="35%">&nbsp;
				  				<%=print_car_no%></td>
                  <td width="15%" class=title>차종</td>
                  <td width="35%">&nbsp;
                  <%=print_car_nm%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>	
	<%}else if(rent_st.equals("2")){
		//정비대차정보
		Hashtable serv = rs_db.getInfoServ(rc_bean.getSub_c_id(), rc_bean.getServ_id());%>
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
                    <td class=title width="15%" style='height:38'>정비공장</td>
                    <td colspan="3"> 
                        &nbsp;
						<%=serv.get("OFF_NM")==null?"":serv.get("OFF_NM")%>
                    </td>
                </tr>
                <tr>
                  <td width="15%" class=title style='height:38'>정비차량번호</td>
                  <td width="35%">&nbsp;
				  <%=serv.get("CAR_NO")==null?"":serv.get("CAR_NO")%></td>
                  <td width="15%" class=title>차종</td>
                  <td width="35%">&nbsp;
                  <%=serv.get("CAR_NM")==null?"":serv.get("CAR_NM")%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>	
	<%}else if(rent_st.equals("3")){
		//사고대차정보
		Hashtable accid = rs_db.getInfoAccid(rc_bean.getSub_c_id(), rc_bean.getAccid_id());
		
		if(mode.equals("accid_doc") && !seq_no.equals("")) accid = rs_db.getInfoAccid(rc_bean.getSub_c_id(), rc_bean.getAccid_id(), seq_no);%>
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
                  <td width="15%" class=title>정비공장</td>
                  <td colspan="3">&nbsp;
				  <input name="off_nm" type="text" class="whitetext" value="<%=accid.get("OFF_NM")==null?"":accid.get("OFF_NM")%>" size="80"></td>
                </tr>
                <tr> 
                    <td class=title width=15%>피해차량번호</td>
                    <td width=35%>&nbsp;<input name="a_car_no" type="text" class="whitetext" value="<%=accid.get("CAR_NO")==null?"":accid.get("CAR_NO")%>" size="30">
                  </td>
                    <td class=title width=15%>차종</td>
                    <td width=35%>&nbsp;<input name="a_car_nm" type="text" class="whitetext" value="<%=accid.get("CAR_NM")==null?"":accid.get("CAR_NM")%>" size="30">
                    </td>
                </tr>
                <tr> 
                    <td width="15%" class=title> 접수번호</td>
                    <td width="35%"> 
                      &nbsp;<input name="a_p_num" type="text" class="whitetext" value="<%=accid.get("P_NUM")==null?"":accid.get("P_NUM")%>" size="30">
                    </td>
                    <td width="15%" class=title>가해자보험사</td>
                    <td width="35%"> 
                      &nbsp;<input name="a_g_ins" type="text" class="whitetext" value="<%=accid.get("G_INS")==null?"":accid.get("G_INS")%>" size="30">
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
	<%}else if(rent_st.equals("9")){
		//보험대차정보
		RentInsBean ri_bean = rs_db.getRentInsCase(s_cd);%>
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
                    <td width="15%" class=title> 접수번호</td>
                    <td width="20%"> 
                      &nbsp;<%=ri_bean.getIns_num()%>
                    </td>
                    <td width="10%" class=title>보험사</td>
                    <td width="30%"> 
                      &nbsp;<select name='ins_com_id' <%=disabled%>>
                        <%if(ic_size > 0){
        					for(int i = 0 ; i < ic_size ; i++){
        						InsComBean ic = ic_r[i];%>
                        <option value="<%=ic.getIns_com_id()%>" <%if(ri_bean.getIns_com_id().equals(ic.getIns_com_id()))%>selected<%%>><%=ic.getIns_com_nm()%></option>
                        <%	}
        				}%>
                      </select>
                    </td>
                    <td width="10%" class=title> 담당자</td>
                    <td width="15%">&nbsp;
                        <%=ri_bean.getIns_nm()%>
                    </td>
                </tr>
                <tr>
                  <td width="15%" class=title>연락처Ⅰ</td>
                  <td>&nbsp;
                      <%=ri_bean.getIns_tel()%>
                  </td>
                  <td width="10%" class=title>연락처Ⅱ</td>
                  <td>&nbsp;
                      <%=ri_bean.getIns_tel2()%>
                  </td>
                  <td width="10%" class=title>팩스</td>
                  <td>&nbsp;
                      <%=ri_bean.getIns_fax()%>
                  </td> 
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>		
	<%}else if(rent_st.equals("6")){
		//차량정비정보
		Hashtable serv = rs_db.getInfoServ(c_id, rc_bean.getServ_id());%>
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
                    <td class=title width=15%>
        			정비공장</td>
                    <td width=35%> 
                      &nbsp;<%=serv.get("OFF_NM")%>
                  </td>
                    <td class=title width=15%> 정비일자</td>
                    <td width=35%>
                      &nbsp;<%=AddUtil.ChangeDate2(String.valueOf(serv.get("SERV_DT")))%>
                  </td>
                </tr>
            </table>
        </td>
    </tr>	
    <tr><td class=h></td></tr>	
	<%}else if(rent_st.equals("7")){
		//차량점검정보
		Hashtable maint = rs_db.getInfoMaint(c_id, rc_bean.getMaint_id());%>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>차량정검</span></td>
    </tr>	
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=15%>검사유효기간</td>
                    <td width=85%>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("MAINT_ST_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("MAINT_END_DT")))%> 
                  </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
	<%}else if(rent_st.equals("8")){
		//사고수리정보
		Hashtable accid = rs_db.getInfoAccid(c_id, rc_bean.getAccid_id());%>
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
                    <td class=title width=15% style='height:37'>
        			정비공장</td>
                    <td width=35%> 
                      &nbsp;<%=accid.get("OFF_NM")%>
                  </td>
                    <td class=title width=10%>사고일자</td>
                    <td width=20%> 
                      &nbsp;<%=AddUtil.ChangeDate2(String.valueOf(accid.get("ACCID_DT")))%>
                  </td>
                    <td class=title width=10%>담당자</td>
                    <td width=10%> 
                      &nbsp;<%=c_db.getNameById(String.valueOf(accid.get("REG_ID")), "USER")%>
                  </td>
                </tr>
                <tr> 
                    <td width="15%" class=title> 사고내용</td>
                    <td colspan="5"> 
                      &nbsp;<%=accid.get("ACCID_CONT")%>&nbsp;<%=accid.get("ACCID_CONT2")%>
                    </td>
                </tr>
          </table>
        </td>
    </tr>		
	<%}%>
	<tr><td class=h></td></tr>					
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>계약정보</span></td>
	    <td align="right"><font color="#999999">
		<%if(!mode.equals("fine_doc") && !mode.equals("accid_doc")){%>
        <%if(!rc_bean.getReg_id().equals("")){%>
        <img src=/acar/images/center/arrow_ccdrj.gif align=absmiddle> : <%=c_db.getNameById(rc_bean.getReg_id(), "USER")%>&nbsp;&nbsp; <img src=/acar/images/center/arrow_ccdri.gif align=absmiddle> : 
        <%=AddUtil.ChangeDate2(rc_bean.getReg_dt())%>
        <%}%>	  
        <%if(!rc_bean.getUpdate_id().equals("")){%>
        &nbsp;&nbsp;<img src=/acar/images/center/arrow_cjsjj.gif align=absmiddle> : <%=c_db.getNameById(rc_bean.getUpdate_id(), "USER")%>&nbsp;&nbsp; <img src=/acar/images/center/arrow_cjsji.gif align=absmiddle> :
        <%=AddUtil.ChangeDate2(rc_bean.getUpdate_dt())%>
        <%}%>
		<%}%>
        </font></td>
    </tr>
    <tr>
        <td class=line2 colspan="2"></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>		  				
                <tr> 
                    <td class=title width=15%>계약일자</td>
                    <td width=20%>&nbsp;
					  <%=AddUtil.ChangeDate2(rc_bean.getRent_dt())%></td>
                    <td class=title width=10%>영업소</td>
                    <td width=25%>&nbsp;
                      <%=c_db.getNameById(rc_bean.getBrch_id(),"BRCH")%>                    
                    </td>
                    <td width=10% class=title>담당자</td>
                    <td width="20%">&nbsp;
                      <%=c_db.getNameById(rc_bean.getBus_id(),"USER")%>                      
                    </td>
                </tr>
                <tr> 
                    <td class=title>기타</td>
                    <td colspan="5"> 
                      &nbsp;<%=rc_bean.getEtc()%>
                    </td>
                </tr>		  
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>배차/반차</span></td>
    </tr>
    <tr>
        <td class=line2 colspan="2"></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width="15%" class=title>배차예정일</td>
                    <td width="35%"> 
                      &nbsp;<%=AddUtil.ChangeDate2(rc_bean.getDeli_plan_dt_d())%>
                    </td>
                    <td width="15%" class=title>반차예정일</td>
                    <td width="35%"> 
                      &nbsp;<%=AddUtil.ChangeDate2(rc_bean.getRet_plan_dt_d())%>
                    </td>
                </tr>
                <tr> 
                    <td class=title width=15%>배차일자</td>
                    <td width=35%> 
                      &nbsp;<%=AddUtil.ChangeDate2(rc_bean.getDeli_dt_d())%>
                    </td>
                    <td class=title width=15%>반차일자</td>
                    <td width=35%>
                      &nbsp;<%=AddUtil.ChangeDate2(rc_bean.getRet_dt_d())%>
        			</td>
                </tr>
                <tr> 
                    <td width="15%" class=title>배차위치</td>
                    <td width="35%"> 
                      &nbsp;<%=rc_bean.getDeli_loc()%>
                    </td>
                    <td width="15%" class=title>반차위치</td>
                    <td width="35%">
					  &nbsp;<%=rc_bean.getRet_loc()%>
					</td>
                </tr>
          </table>
        </td>
    </tr>
<!-- 사고대차 화면 출력 양식 요청해서 임시로 작업함. 2009-05-08 여기서 부터-->    
	<tr>
		<td height=15></td>
	</tr>
	<%{
			Hashtable serv = rs_db.getInfoServ(rc_bean.getSub_c_id(), rc_bean.getServ_id());
			
			if(!rc_bean.getSub_c_id().equals("") && print_car_no.equals("")){
				print_car_no = String.valueOf(serv.get("CAR_NO"))==null?"":String.valueOf(serv.get("CAR_NO"));
				print_car_nm = String.valueOf(serv.get("CAR_NM"))==null?"":String.valueOf(serv.get("CAR_NM"));
			}
			
			if(print_car_no.equals("null")){ print_car_no="";}
			if(print_car_nm.equals("null")){ print_car_nm="";}
			
			
	%>
    <tr>
    	<td>&nbsp;&nbsp;&nbsp;&nbsp;
    	  <%if(rent_st.equals("12")){%>
    	  위 고객은 <b><%=reserv.get("CAR_NO")%> <%=reserv.get("CAR_NM")%> </b>차량을 월렌트계약하여 <b><%=AddUtil.ChangeDate2(rc_bean.getDeli_dt_d())%> ~ <%if(!rc_bean.getRet_dt_d().equals("")){%><%=AddUtil.ChangeDate2(rc_bean.getRet_dt_d())%><%}else{%><%=AddUtil.ChangeDate2(rc_bean.getRet_plan_dt_d())%><%}%></b> 까지 제공함을 증명함.
    	  <%}else{%>
    	  위 고객은 <b><input name="car_no2" type="text" class="whitetext" value="<%=print_car_no%>" size="12"> <%=print_car_nm%> </b>차량을 <%if(rc_bean.getRent_st().equals("10")){%>장기계약하였으나 미출고로 지연대차서비스를<%}else{%>장기계약하여 이용하던중 대차 서비스를<%}%> <b><%=AddUtil.ChangeDate2(rc_bean.getDeli_dt_d())%> ~ <p>&nbsp;&nbsp;&nbsp;<%if(!rc_bean.getRet_dt_d().equals("")){%><%=AddUtil.ChangeDate2(rc_bean.getRet_dt_d())%><%}else{%><%=reg_dt%><%}%></b> 까지 <b><input name="car_no3" type="text" class="whitetext" value="<%=reserv.get("CAR_NO")%>" size="12"></b> 차량으로 제공 하였슴을 증명함.
    	  <%}%>
    	</td>
    </tr>
    <%}%>
	<tr>
		<td align=right><img src=/acar/images/pay_h_ceo.gif></td>
	</tr>    
<!-- 여기까지 -->	
   
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>

