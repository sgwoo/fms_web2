<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*, acar.user_mng.*, acar.doc_settle.*" %>
<%@ page import="acar.car_sche.*,acar.common.*" %>
<%@ page import="acar.schedule.*, acar.attend.*, acar.closeday.*" %>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="cd_db" scope="page" class="acar.closeday.CloseDayDatabase"/>
<jsp:useBean id="u_bean" class="acar.user_mng.UsersBean" scope="page" />
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	LoginBean login = LoginBean.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();	
	
	String id = "";			
	String user_h_tel ="";
	String user_m_tel ="";
	String br_nm = "";
	String dept_nm = "";
	String user_nm = "";

	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");// 연차신청자
	
	
	String chk1 = request.getParameter("chk1")==null?"d":request.getParameter("chk1");	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");	
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");	
	int s_year = request.getParameter("s_year")==null?AddUtil.getDate2(1):Integer.parseInt(request.getParameter("s_year"));	
	int s_month = request.getParameter("s_month")==null?AddUtil.getDate2(2):Integer.parseInt(request.getParameter("s_month"));	
	int s_day = request.getParameter("s_day")==null?AddUtil.getDate2(3):Integer.parseInt(request.getParameter("s_day"));
	int seq = request.getParameter("seq")==null?1:Util.parseInt(request.getParameter("seq"));
	String doc_no = request.getParameter("doc_no")==null?"":request.getParameter("doc_no");	
	String doc_st = request.getParameter("doc_st")==null?"":request.getParameter("doc_st");	
	
	String  login_id = request.getParameter("login_id")==null?"":request.getParameter("login_id");  //로그인 id

	login_id = login.getCookieValue(request, "acar_id");
		
	u_bean = umd.getUsersBean(user_id);
	user_nm = u_bean.getUser_nm();
	br_nm = u_bean.getBr_nm();
	dept_nm = u_bean.getDept_nm();

	String dept_id = c_db.getUserDept(user_id);
	
	//연차신청정보
	Vector vt2 = cd_db.CloseDay_per(user_id, doc_no);
	int vt2_size = vt2.size();
	
	//문서품의
	DocSettleBean doc = d_db.getDocSettleOver_time("23", doc_no);  
	
%>

<HTML>
<HEAD>
<TITLE>FMS</TITLE>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language='javascript'>
<!--

function LoadSche()
{
	var theForm = opener.document.form1;
	theForm.submit();
	self.close();
	window.close();
}

function get_length(f) {
	var max_len = f.length;
	var len = 0;
	for(k=0;k<max_len;k++) {
		t = f.charAt(k);
		if (escape(t).length > 4)
			len += 2;
		else
			len++;
	}
	return len;
}

//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		theURL = "https://fms3.amazoncar.co.kr/data/free_time/"+theURL;
		window.open(theURL,winName,features);
	}
	

function check()
{
	var theForm = document.form1;
	var len = theForm.elements.length;
	
	theForm.cmd.value="cm";
	theForm.doc_bit.value = "2";
	theForm.doc_step.value = "3";
		
	if(confirm('결재하시겠습니까?')){			

		theForm.action='closeday_sk.jsp';		
		theForm.target='i_no';
		theForm.submit();
	}						
}		

function Closeday_del()
{
	var theForm = document.form1;
	theForm.cmd.value = "d";
		
	if(confirm('삭제하시겠습니까?')){	
			theForm.action='closeday_sk.jsp';		
			theForm.target='i_no';
			theForm.submit();
	}
}

//리스트 가기	
function go_to_list()
{
	var fm = document.form1;
	location = "closeday_frame.jsp";
	
}


//20090603
//팝업윈도우 열기
function MM_openBrWindow(theURL,winName,features) { //v2.0
	window.open(theURL,winName,features);
}

function show_close()
{
	self.close();
}


//-->
</script>
</HEAD>
<body>
<form action="./free_time_u.jsp" name="form1" method="post" >
<input type="hidden" name="user_id" value="<%=user_id%>">	
<input type='hidden' name="doc_bit" value="">          
<input type='hidden' name="doc_step" value="">
<input type='hidden' name="doc_st" value="23">
<input type='hidden' name="doc_no" value="<%=doc_no %>">    
<input type="hidden" name="year" value="">
<input type="hidden" name="cmd" value="">	

<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<%if(vt2_size > 0){
		for(int i = 0 ; i < vt2_size ; i++){
			Hashtable ht2 = (Hashtable)vt2.elementAt(i); %>	
	<tr>
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>인사관리 > 근태관리 > <span class=style5><%= ht2.get("USER_NM") %>님 중식대 신청내역</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
		<td class=h></td>
	</tr>
	<tr>
		<td align='right'>
		<a href="javascript:go_to_list()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_list.gif" align=absmiddle border=0></a></td>
	</tr>
  
    <!-- 결재여부 시작 -->
    
    <tr>
	    <td class=line2></td>
	</tr>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width="100%">
				<tr>
					<td width="12%" align="center" class="title">품의일자</td>
					<td align="center" width=14%><%=AddUtil.ChangeDate2(String.valueOf(ht2.get("REG_DT")))%></td>					
					<td width="12%" align="center" class="title">부서명</td>
					<td align="center" width=16%><%= ht2.get("BR_NM") %>-<%= ht2.get("DEPT_NM") %></td>
					<td width="12%" align="center" class="title">사원번호</td>
					<td align="center" width=12%><%= ht2.get("ID") %></td>
					<td width="9%" align="center" class="title">성명</td>
					<td align="center" width=13%><%= ht2.get("USER_NM") %></td>
				</tr>
				<tr>
				<td class="title">내용 </td>
				<td colspan="7" height="25%">&nbsp;&nbsp;&nbsp;<%=ht2.get("CONTENT")%> </td>
				</tr>
				
			</table>
		</td>
	</tr>
	<tr>
	    <td class=h></td>
	</tr>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width="100%">
				<tr>
					<td width="12%" rowspan="2" class="title">결재</td>
					<td width="28%" align="center" class="title">신청자</td>
					<td width="26%" align="center" class="title">팀장</td>
					<td align="center" class="title"></td>					
				</tr>
				<tr>
				  <td align="center"><%= ht2.get("USER_NM") %></td>
				  				  
			      <td align="center"><%=c_db.getNameById(doc.getUser_id2(),"USER_PO")%><br><%=doc.getUser_dt2()%>
        			  <%if(doc.getUser_dt2().equals("")){
        			  		String user_id2 = doc.getUser_id2();
        					        			
        					%>
        			  <%	if(user_id2.equals(login_id) || nm_db.getWorkAuthUser("전산팀",login_id) ){%>
        			    <a href="javascript:check()"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>
        			  <%	}%>
        			    <br>&nbsp;
        			  <%}%>
        		  </td>  
			  </tr>
			</table>
		</td>
	</tr>	
<!-- 결재여부 끝 -->
    <tr>
        <td class=h></td>
    </tr>
	
			<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
			<input type="hidden" name="login_id" value="<%=login_id%>">
			<input type="hidden" name="dept_id" value="<%=dept_id%>">
			<input type="hidden" name="s_kd" value="<%=s_kd%>">
			<input type="hidden" name="t_wd" value="<%=t_wd%>">
			<input type="hidden" name="s_year" value="<%=s_year%>">
			<input type="hidden" name="s_month" value="<%=s_month%>">
			<input type="hidden" name="s_day" value="<%=s_day%>">			
			<input type="hidden" name="st_dt" value="<%=ht2.get("START_DATE")%>">	
			<input type="hidden" name="end_dt" value="<%=ht2.get("END_DATE")%>">						
			<input type="hidden" name="title" value="<%=ht2.get("TITLE")%>">
			<input type="hidden" name="content" value="<%=ht2.get("CONTENT")%>">
			<input type="hidden" name="sch_chk" value="<%=ht2.get("SCH_CHK")%>">
			<input type="hidden" name="work_id" value="<%=ht2.get("WORK_ID")%>">
	
<%}}%>
	
<% 			if(nm_db.getWorkAuthUser("임원",login_id) || nm_db.getWorkAuthUser("전산팀",login_id) || nm_db.getWorkAuthUser("지점장",login_id)){%>

	<tr>
		<td align='right'>&nbsp;
			<a href="javascript:Closeday_del()"><img src=/acar/images/center/button_delete.gif border=0 align=absmiddle></a>		
		</td>
	</tr>		
<%		}%>	
	
</form>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize ></iframe>
</BODY>
</HTML>
