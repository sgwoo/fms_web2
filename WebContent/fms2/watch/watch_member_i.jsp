<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*,  acar.common.*, acar.watch.*"%>
<jsp:useBean id="wc_bean" class="acar.watch.WatchScheBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	WatchDatabase wc_db = WatchDatabase.getInstance();
	
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String start_year 	= request.getParameter("start_year")==null?"":request.getParameter("start_year");
	String start_month 	= request.getParameter("start_month")==null?"":request.getParameter("start_month");
	String start_day 	= request.getParameter("start_day")==null?"":request.getParameter("start_day");
	String member_st 	= request.getParameter("member_st")==null?"":request.getParameter("member_st");
	String member_id 	= request.getParameter("member_id")==null?"":request.getParameter("member_id");
	String cmd			= "";
	int count = 0;
	String watch_type = request.getParameter("watch_type")==null?"":request.getParameter("watch_type");		
	String week = request.getParameter("week")==null?"":request.getParameter("week");
	String is_registered_watch = request.getParameter("is_registered_watch") == null ? "" : request.getParameter("is_registered_watch");
				
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	Vector users = new Vector();
	int user_size = 0;
		
	if (watch_type.equals("1") ) {
		if ( week.equals("1") ||  week.equals("7") ) {
			users = c_db.getUserList("", "", "WATCH_J");
			user_size = users.size();	
			
		} else {
			users = c_db.getUserList("", "", "WATCH");
			user_size = users.size();
			
		}	
	} else if (watch_type.equals("34") ) {
		users = c_db.getUserList("", "", "WATCH_BGDK");//부산+대구+대전+광주
		user_size = users.size();
		
	} else if (watch_type.equals("3") ) {
			users = c_db.getUserList("", "", "WATCH_BG");//부산+대구
			user_size = users.size();
			
	} else 	if (watch_type.equals("4") ) {
			users = c_db.getUserList("", "", "WATCH_DK");//대전+광주
			user_size = users.size();	
	
	} else 	if (watch_type.equals("6") ) {
			users = c_db.getUserList("", "", "WATCH_KJ");//광주
			user_size = users.size();	
	
	} else 	if (watch_type.equals("7") ) {
			users = c_db.getUserList("", "", "WATCH_G");
			user_size = users.size();	

	} else 	if (watch_type.equals("5") ) {
			users = c_db.getUserList("", "", "WATCH_SIK3");//수도권남부(강남+인천+수원)
			user_size = users.size();	
			
	} else 	if (watch_type.equals("8") ) {
			users = c_db.getUserList("", "", "WATCH_I");
			user_size = users.size();
	} else 	if (watch_type.equals("9") ) {
			users = c_db.getUserList("", "", "WATCH_K3");
			user_size = users.size();
	}
		

%>
<HTML>
<HEAD>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table_t.css">

<script language='javascript'>
<!--
function ScheReg()
{
	var theForm = document.ScheRegForm;
 theForm.cmd.value='SS';
	if(!confirm('등록하시겠습니까?'))
	{
		return;
	}
	
	theForm.target = "i_no";
	theForm.submit();
}
//-->
</script>
<script language="JavaScript" src="/include/common.js"></script>
<%@ include file="/acar/getNaviCookies.jsp" %>
</HEAD>
<BODY>
<%if(wc_bean.getMember_id().equals("")){%>
<form action="watch_member_i_a.jsp" name='ScheRegForm' method='post'>
            <input type="hidden" name="start_year" value="<%=start_year%>">
            <input type="hidden" name="start_month" value="<%=start_month%>">
            <input type="hidden" name="start_day" value="<%=start_day%>">
            <input type="hidden" name="watch_type" value="<%=watch_type%>">
            <input type="hidden" name="week" value="<%=week%>">
            <input type="hidden" name="is_registered_watch" value="<%=is_registered_watch%>">
          
            <input type="hidden" name="cmd" value="">

<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>인사관리 > 당직근무 >  <span class=style5>등록</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>

    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width="" class='title'>당직자</td>
                    <td> 
                      &nbsp;&nbsp;
					 <select name='member_id' onchange="javascript:ScheReg()">
		                <option value="" selected>근무자선택</option>
		                <%	if(user_size > 0){
								for(int i = 0 ; i < user_size ; i++){
									Hashtable user = (Hashtable)users.elementAt(i); %>
									<%if(!user.get("USER_ID").equals("000056")){ 	//최은아 과장님 야간 당직 리스트에서 제외%>
		                <option value='<%=user.get("USER_ID")%>' <%if(ck_acar_id.equals(user.get("USER_ID"))){%><%}%>><%=user.get("USER_NM")%></option>
		                			<%} %>
		                <%		}
							}%>
		              </select><!--&nbsp;&nbsp;&nbsp;<a href="javascript:ScheReg()"><img src=/acar/images/center/button_in_reg.gif border=0  align=absmiddle></a>--></td>
                </tr>
            </table>
        </td>
</table>
</form>
<%}else{%>
<script language="JavaScript">
<!--
	//alert("정상적으로 등록되었습니다.");
	opener.LoadSche();
	window.close();
//-->
</script>	
<%}%>
<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize ></iframe> 
</BODY>
</HTML>
