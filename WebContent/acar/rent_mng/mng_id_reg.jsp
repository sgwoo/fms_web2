<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.res_search.*, acar.util.*, acar.user_mng.*, acar.cont.* "%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<jsp:useBean id="a_db"      class="acar.cont.AddContDatabase"          scope="page"/>
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
	String sort_gubun = request.getParameter("sort_gubun")==null?"a.car_nm":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");

	String s_cd = request.getParameter("s_cd")==null?"":request.getParameter("s_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");		
	String f_page = request.getParameter("f_page")==null?"":request.getParameter("f_page");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String list_from_page = request.getParameter("list_from_page")==null?"":request.getParameter("list_from_page");
	
	
	String mngid_reg_brch_id = request.getParameter("mngid_reg_brch_id")==null?"":request.getParameter("mngid_reg_brch_id");
	
	//로그인ID&영업소ID&권한
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals(""))	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals("")) 	br_id = login.getCookieValue(request, "acar_br");
	auth_rw = rs_db.getAuthRw(user_id, "02", "01", "03");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	
	//담당자 리스트
	Vector users = new Vector();
	
	if(mngid_reg_brch_id.equals("S1")){	
		users = c_db.getUserList("0002", "", "RM_MNG"); 
	}else if(mngid_reg_brch_id.equals("S2")){	
		users = c_db.getUserList("0002", "", "RM_MNG"); 
	}else if(mngid_reg_brch_id.equals("I1")){	
		users = c_db.getUserList("0002", "", "RM_MNG"); 
	}else if(mngid_reg_brch_id.equals("K3")){	
		users = c_db.getUserList("", "", "RM_MNG_K3");
	}else if(mngid_reg_brch_id.equals("B1")){	
		users = c_db.getUserList("", "", "RM_MNG_B");
	}else if(mngid_reg_brch_id.equals("D1")){	
		users = c_db.getUserList("", "", "RM_MNG_D");
	}else{
		users = c_db.getUserList("0002", "", "RM_MNG"); 
	}
	
	if(!mngid_reg_brch_id.equals("S1") && br_id.equals("S1")){	
		users = c_db.getUserList("0002", "", "RM_MNG"); 
	}
	
	int user_size = users.size();	

	//차량정보
	Hashtable reserv = rs_db.getCarInfo(c_id);
	
	//단기계약정보
	RentContBean rc_bean = rs_db.getRentContCase(s_cd, c_id);
	//고객정보
	RentCustBean rc_bean2 = rs_db.getRentCustCase(rc_bean.getCust_st(), rc_bean.getCust_id());
	String rent_st = rc_bean.getRent_st();
	
		
	//담당자
	user_bean 	= umd.getUsersBean(rc_bean.getMng_id());
	
	
	//동일업체 담당자가 있으면 표시해줌
	Vector mngs = rs_db.getRentContCustHList(rc_bean.getRent_st(), rc_bean.getCust_id(), rc_bean.getRent_s_cd());
	int mng_size = mngs.size();
	
	//보유차정보
	Hashtable cont = a_db.getContViewUseYCarCase(c_id);
	

%>

<html>
<head>

<title>예약시스템 <%if(mode.equals("R")){%>반차처리<%}else{%>기간연장<%}%></title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='JavaScript'>
	//저장하기
	function save(){
		var fm = document.form1;
		if(fm.mng_id.value == ''){ alert('변경후 관리담당자를 선택하십시오'); fm.mng_id.focus(); return; }	
		if(!confirm('변경하시겠습니까?')){	return;	}
		fm.action = 'mng_id_reg_a.jsp';
		fm.target = 'i_no';
		fm.submit();			
	}
	
		
</script>
</head>
<body>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<form action="" name="form1" method="post" >
 <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
 <input type='hidden' name='user_id' value='<%=user_id%>'>
 <input type='hidden' name='br_id' value='<%=br_id%>'>
 <input type='hidden' name='gubun1' value='<%=gubun1%>'>  
 <input type='hidden' name='gubun2' value='<%=gubun2%>'>   
 <input type='hidden' name='brch_id' value='<%=brch_id%>'> 
 <input type='hidden' name='start_dt' value='<%=start_dt%>'> 
 <input type='hidden' name='end_dt' value='<%=end_dt%>'>   
 <input type='hidden' name='car_comp_id' value='<%=car_comp_id%>'>   
 <input type='hidden' name='code' value='<%=code%>'>     
 <input type='hidden' name='s_kd'  value='<%=s_kd%>'>
 <input type='hidden' name='t_wd' value='<%=t_wd%>'>			 
 <input type='hidden' name='s_cc' value='<%=s_cc%>'>
 <input type='hidden' name='s_year' value='<%=s_year%>'> 
 <input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'> 
 <input type='hidden' name='asc' value='<%=asc%>'> 
 <input type='hidden' name='car_no' value='<%=reserv.get("CAR_NO")%>'>        
 <input type='hidden' name='c_firm_nm' value='<%=rc_bean2.getFirm_nm()%>'>         
 <input type='hidden' name='c_client_nm' value='<%=rc_bean2.getCust_nm()%>'>    
 <input type='hidden' name='from_page' value='<%=from_page%>'>
 <input type='hidden' name='list_from_page' value='<%=list_from_page%>'>


<input type='hidden' name='s_cd' value='<%=s_cd%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
       
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>예약시스템 > 월렌트관리 > <span class=style5>관리담당자 배정</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>  
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>보유차 정보</span></td>
    </tr>    
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
	    <td class='line'>
	        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                  <tr> 
                    <td width='15%' class='title'>계약번호</td>
                    <td colspan="3">&nbsp;<%=cont.get("RENT_L_CD")%></td>
                  </tr>                  
                  <tr> 
                    <td width='15%' class='title'>영업담당자</td>
                    <td width='35%'>&nbsp;<%=c_db.getNameById(String.valueOf(cont.get("BUS_ID2")),"USER")%></td>                    
                    <td width='15%' class='title'>관리담당자</td>
                    <td width='35%'>&nbsp;<%=c_db.getNameById(String.valueOf(cont.get("MNG_ID")),"USER")%></td>                    
                  </tr>                  
                </table>
	    </td>	    
	</tr>  
    <tr>
        <td class=h></td>
    </tr>  	
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>월렌트 정보</span></td>
    </tr>              
    <tr><td class=line2></td></tr>  
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='15%' class=title>계약구분</td>
                    <td width='35%'> 
                      <%if(rent_st.equals("1")){%>
                      &nbsp;단기대여 
                      <%}else if(rent_st.equals("2")){%>
                      &nbsp;정비대차 
                      <%}else if(rent_st.equals("3")){%>
                      &nbsp;사고대차 
                      <%}else if(rent_st.equals("9")){%>
                      &nbsp;보험대차 			  
                      <%}else if(rent_st.equals("10")){%>
                      &nbsp;지연대차 			  
                      <%}else if(rent_st.equals("4")){%>
                      &nbsp;업무대여 
                      <%}else if(rent_st.equals("5")){%>
                      &nbsp;업무지원 
                      <%}else if(rent_st.equals("6")){%>
                      &nbsp;차량정비 
                      <%}else if(rent_st.equals("7")){%>
                      &nbsp;차량점검 
                      <%}else if(rent_st.equals("8")){%>
                      &nbsp;사고수리 
                      <%}else if(rent_st.equals("11")){%>
                      &nbsp;기타 
                      <%}else if(rent_st.equals("12")){%>
                      &nbsp;월렌트
                      <%}%>
                    </td>
                    <td class=title width=15%>차량번호</td>
                    <td width=35%>&nbsp;<%=reserv.get("CAR_NO")%></td>
                <tr>                     
                    <td class=title>성명</td>
                    <td>&nbsp;<%=rc_bean2.getCust_nm()%></td>
                    <td class=title>상호</td>
                    <td>&nbsp;<%=rc_bean2.getFirm_nm()%></td>
                </tr>
                <tr> 
                    <td class=title>대여기간</td>
                    <td colspan="3">&nbsp;<%=AddUtil.ChangeDate3(rc_bean.getRent_start_dt())%>
                     ~ <%=AddUtil.ChangeDate3(rc_bean.getRent_end_dt())%></td>
                </tr>
                <tr> 
                    <td class=title>배차일시</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate3(rc_bean.getDeli_dt())%></td>
                    <td class=title>최초영업자</td>
                    <td>&nbsp;<%=c_db.getNameById(rc_bean.getBus_id(),"USER")%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>      	
    <tr><td class=line2></td></tr> 
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title rowspan="2" width=15%>관리담당자</td>
                    <td class=title width=15%>변경전</td>
                    <td>
                      &nbsp;<%=user_bean.getUser_nm()%>
                    </td>
                </tr>
                <tr> 
                    <td class=title>변경후</td>
                    <td> 
                      &nbsp;<select name='mng_id'>
                        <option value="">미지정</option>
                        <%if(mngid_reg_brch_id.equals(br_id)){	%>
                        <%if(mngid_reg_brch_id.equals("B1")){%>
                        <option value='000053' >제인학</option>	
                        <%}%>
                        <%if(mngid_reg_brch_id.equals("D1")){%>
                        <option value='000052' >박영규</option>		
                        <%}%>
                        <%}%>
                        <%if(user_size > 0){
        					for (int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i);	%>
                        <option value='<%=user.get("USER_ID")%>' <%if(rc_bean.getBus_id().equals(String.valueOf(user.get("USER_ID")))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                        <%	}
        				}%>
        		<%if(br_id.equals("S1")){
        			users = c_db.getUserList("", "", "WATCH_B");
        			user_size = users.size();	%>
        		<option value='' >==부산지점==</option>	
        		
        		<%if(user_size > 0){
        					for (int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i);	%>
                        <option value='<%=user.get("USER_ID")%>' <%if(rc_bean.getBus_id().equals(String.valueOf(user.get("USER_ID")))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                        <%	}
        				}%>
        		<%	users = c_db.getUserList("", "", "WATCH_D");
        			user_size = users.size();%>
        		<option value='' >==대전지점==</option>	
        		
			<%if(user_size > 0){
        					for (int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i);	%>
                        <option value='<%=user.get("USER_ID")%>' <%if(rc_bean.getBus_id().equals(String.valueOf(user.get("USER_ID")))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                        <%	}
        				}%>        								        		
        		<%}%>
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td class=title colspan='2'>안내여부</td>                    
                    <td>
                      &nbsp;<input type='checkbox' name='sms_reg' value='Y' checked> 고객에게 관리담당자 변경 안내문자 발송
                    </td>
                </tr>                
            </table>
        </td>
    </tr>   
    <tr>
        <td>* 변경후 담당자에게 배정 메시지가 갑니다.</td>
    </tr>  		
    <tr>
        <td>* 안내여부에 체크한 상태에서 변경하면 고객에게 안내문자가 갑니다.</td>
    </tr>  		
    <tr>
        <td class=h></td>
    </tr>  		
	<tr>
	    <td align="right">
	  	<%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>		  	  	  
		 <a href='javascript:save();'><img src="/acar/images/center/button_conf.gif" border="0" align=absmiddle></a>
	  	<%}%>			
		&nbsp;<a href="javascript:window.close()"><img src="/acar/images/center/button_close.gif"  border="0" align=absmiddle></a>				
	    </td>
	</tr>
    <%	if(mng_size > 0){%>	
    <tr> 
        <td>[ 고객 배정리스트 ]</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>      	
    <tr><td class=line2></td></tr> 
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=6%>연번</td>
                    <td class=title width=8%>계약구분</td>
                    <td class=title width=8%>상태구분</td>
                    <td class=title width=10%>계약일자</td>
                    <td class=title width=10%>차량번호</td>
                    <td class=title width=19%>배차일시</td>
                    <td class=title width=19%>반차일시</td>                    
                    <td class=title width=10%>최초영업자</td>
                    <td class=title width=10%>관리담당자</td>                    
                </tr>    
    		<%	for(int i = 0 ; i < mng_size ; i++){
    				Hashtable mng = (Hashtable)mngs.elementAt(i);%>	
                <tr> 
                    <td align='center'><%=i+1%></td>
                    <td align='center'><%=mng.get("RENT_ST_NM")%></td>
                    <td align='center'><%=mng.get("USE_ST_NM")%></td>
                    <td align='center'><%=AddUtil.ChangeDate2(String.valueOf(mng.get("RENT_DT")))%></td>
                    <td align='center'><%=mng.get("CAR_NO")%></td>
                    <td align='center'><%=AddUtil.ChangeDate3(String.valueOf(mng.get("DELI_DT")))%><%if(String.valueOf(mng.get("DELI_DT")).equals("")){%><%=AddUtil.ChangeDate3(String.valueOf(mng.get("DELI_PLAN_DT")))%><%}%></td>
                    <td align='center'><%=AddUtil.ChangeDate3(String.valueOf(mng.get("RET_DT")))%><%if(String.valueOf(mng.get("RET_DT")).equals("")){%><%=AddUtil.ChangeDate3(String.valueOf(mng.get("RET_PLAN_DT")))%><%}%></td>
                    <td align="center"><%=mng.get("BUS_NM")%></td>
                    <td align="center"><%=mng.get("MNG_NM")%></td>
                </tr>    
                <%	}%>
            </table>
        </td>
    </tr>       
    <%	}%>	
</table>
</form>
<script language="JavaScript">
<!--	
//-->
</script>
</body>
</html>
