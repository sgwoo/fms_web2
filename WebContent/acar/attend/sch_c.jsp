<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.car_sche.*, acar.schedule.*" %>
<jsp:useBean id="aa_db" scope="page" class="acar.attend.AttendDatabase"/>
<jsp:useBean id="cd_db" scope="page" class="acar.closeday.CloseDayDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한	
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String start_year = request.getParameter("start_year")==null?"":request.getParameter("start_year");
	String start_mon = request.getParameter("start_mon")==null?"":request.getParameter("start_mon");
	String start_day = request.getParameter("start_day")==null?"":request.getParameter("start_day");
	
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	
	
	Hashtable prv =  aa_db.getAttendUserPrvContent(user_id, start_year, start_mon, start_day);
	

%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language='javascript'>
<!--
function reg()
{
	var theForm = document.ScheDispForm;
	if(theForm.content.value == ''){	alert("중식대 신청내용를 입력하십시오.");	return;	}
	if(get_length(theForm.content.value) > 4000){alert("4000자 까지만 입력할 수 있습니다."); return; }

	if(!confirm('등록하시겠습니까?'))
	{
		return;
	}
	
	theForm.cmd.value = "i";
	theForm.action = "http://fms1.amazoncar.co.kr/fms2/closeday/closeday_a.jsp";	
	theForm.submit();
}

function free_close()
{
	var theForm = opener.document.ScheDispForm;
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
//-->
</script>
</HEAD>
<BODY>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>인사관리 > 근태관리 > 출근관리 > <span class=style5>스케줄</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<form action="" name='ScheDispForm' method='post'>
		<input type="hidden" name="user_id" value="<%=user_id%>">
		<input type="hidden" name="start_year" value="<%=start_year%>">
		<input type="hidden" name="start_mon" value="<%=start_mon%>">
		<input type="hidden" name="start_day" value="<%=start_day%>">
		<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
		<input type="hidden" name="cmd" value="">
		<input type="hidden" name="sch_chk" value='<%=prv.get("SCH_CHK")%>'>
	<tr>
		<td align='right' width=680>
<%if(!mode.equals("view") && String.valueOf(prv.get("SCH_CHK")).equals("연차")){%>			
		<a href="javascript:reg()"><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a>
<% } %>		
		<a href="javascript:self.close();"><img src=../images/center/button_close.gif border=0 align=absmiddle></a> 
		</td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>

	<tr>
		<td class='line'>			
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width=100 class='title'>이름</td>
                    <td width=200 align=center>&nbsp;<%=c_db.getNameById(user_id, "USER")%></td>
                    <td width=100 class='title'>일자</td>
                    <td width=280 align=center>&nbsp;<%=start_year%>년&nbsp;<%=start_mon%>월&nbsp;<%=start_day%>일</td>
                </tr>
                <tr> 
                   <td class='title' >구분</td>
                   <td class='title' >제목</td>
                   <td class='title' colspan="2">내용</td>
                </tr>
        			    
                <tr> 
                    <td align="center"><%=prv.get("SCH_CHK")%></td>
                    <td>
                        <table border="0" cellspacing="0" cellpadding="5">
			                <tr>
				                <td align="center"><%=prv.get("TITLE")%></td>
				            </tr>
			            </table>
			        </td>
                    <td colspan="2">
			            <table border="0" cellspacing="0" cellpadding="5">
			                <tr>
				                <td align="center"><%=prv.get("CONTENT")%></td>
				            </tr>
			            </table>
			        </td>
                </tr>
<%if(!mode.equals("view") && String.valueOf(prv.get("SCH_CHK")).equals("연차")){%>				

				<tr>
					<td colspan="4"><font color=red>※</font>&nbsp;연차중 회사업무로 인해 중식대를 신청할때는 아래 내용을 작성하고 등록을 해주시기 바랍니다.<br>(단, 사무실로 이동을 하였을 경우만 해당) </td>
				</tr>
				<tr>
					<td class='title' width="">중식대 <br>신청내용</td>
					<td colspan="3">&nbsp;<textarea name='content' rows='9' cols='96' value=''>
					<%
//연차신청정보
	String yday = start_year+""+start_mon+""+start_day;
	Vector vt = cd_db.CloseDay_day(user_id, yday);
	int vt_size = vt.size();
		for(int j = 0 ; j < vt_size ; j++){
			Hashtable ht = (Hashtable)vt.elementAt(j);
%>
					<%=ht.get("CONTENT")%>
<%}%>					
					</textarea></td>
				</tr>

<%	}%>
            </table>
		</td>
    </tr>
</table>	
</form>
</table>
</BODY>
</HTML>
