<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.attend.*, acar.schedule.*" %>
<jsp:useBean id="calendar" class="acar.car_sche.CalendarBean" scope="page"/>
<jsp:useBean id="aa_db" scope="page" class="acar.attend.AttendDatabase"/>
<jsp:useBean id="bean" class="acar.attend.AttendBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language="JavaScript" src='/include/common.js'></script>
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='javascript'>
<!--
	/* Title 고정 */
	function setupEvents(){
		window.onscroll = moveTitle ;
		window.onresize = moveTitle ; 
	}
	
	function moveTitle(){
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    	    
	}
	
	function init(){		
		setupEvents();
	}	
	

	function ScheDisp(user_id, year, mon, day){
		var theForm = document.thefrm;
		var url = "?user_id=" + user_id
				+ "&start_year=" + year 
				+ "&start_mon=" + mon
				+ "&start_day=" + day;
		var SUBWIN="sch_c.jsp" + url;		
		window.open(SUBWIN, "SchDisp", "left=100, top=100, width=720, height=400, scrollbars=yes");
	}	
	
	function AttendReg(user_id, year, mon, day){
		var theForm = document.thefrm;
		var url = "?user_id=" + user_id
				+ "&start_year=" + year 
				+ "&start_mon=" + mon
				+ "&start_day=" + day;
		var SUBWIN="sch_reason_i.jsp" + url;		
		window.open(SUBWIN, "SchDisp", "left=100, top=100, width=720, height=400, scrollbars=yes");
	}	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href=../../include/table_t.css>
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
//	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	String chk1 = request.getParameter("chk1")==null?"d":request.getParameter("chk1");	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");	
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");	
	String s_year = request.getParameter("s_year")==null?"":request.getParameter("s_year");	
	String s_month = request.getParameter("s_month")==null?"":AddUtil.addZero(request.getParameter("s_month"));
	String s_day = request.getParameter("s_day")==null?"":AddUtil.addZero(request.getParameter("s_day"));
	int days = AddUtil.getMonthDate(Integer.parseInt(s_year), Integer.parseInt(s_month));
	
	Vector users = aa_db.getAttendUser2(s_kd, t_wd);
	int user_size = users.size();
%>
<form name='form1' action='' target='MAPPING' method="POST">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="s_kd" value="<%=s_kd%>">
<input type="hidden" name="t_wd" value="<%=t_wd%>">
<input type="hidden" name="s_year" value="<%=s_year%>">
<input type="hidden" name="s_month" value="<%=s_month%>">
<input type="hidden" name="s_day" value="<%=s_day%>">
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>		
        <td class=line>	
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width=5% rowspan="2" class='title'>연번</td>
                    <td width=11% rowspan="2" class='title'>근무지</td>
                    <td width=11% rowspan="2" class='title'>부서</td>
                    <td width=10% rowspan="2" class='title'>이름</td>
                    <td width=10% rowspan="2" class='title'>직위</td>
                    <td colspan="3" class='title'><%=s_year%>년 <%=s_month%>월 
                      <%=s_day%>일 출근 정보 
                      <%if(AddUtil.getDate().equals(s_year+"-"+s_month+"-"+s_day)){%>
                      (당일) 
                      <%}%>
                      </td>
                </tr>
                <tr align="center"> 
                    <td width=8% class='title'>구분</td>
                    <td width=13% class='title'>로그인시간</td>
                    <td width=32% class='title'>적요</td>
                </tr>
                <tr bgcolor=#FFFEEE align="center"> 
                    <td colspan="8" class='title'>&nbsp;<font color="#FF0000"><%=aa_db.getHoliday(s_year+s_month+s_day)%>&nbsp;</font></td>
                </tr>
            </table>
		</td>
	</tr>
<%	if(user_size > 0){	%>
	<tr>
		<td class=line>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
              <%for(int i = 0 ; i < user_size ; i++){
    				Hashtable user = (Hashtable)users.elementAt(i);
    				String user_id = String.valueOf(user.get("USER_ID"));
    				AttendBean ab = aa_db.getAttendUserDay(user_id, s_year, s_month, s_day);
    				AttendBean ab2 = new AttendBean();
    				if(ab.getLogin_dt().equals("")){//로그인 없으면
    					ab2 = aa_db.getAttendUserPrv(user_id, s_year, s_month, s_day);
    				}%>
                <tr bgcolor="#FFFFFF"> 
                    <td width=5% align='center' height="20"><%=i+1%></td>
                    <td width=11% align='center' height="20"><%=user.get("BR_NM")%></td>
                    <td width=11% align='center' height="20"><%=user.get("DEPT_NM")%></td>
                    <td width=10% align='center' height="20"><%=user.get("USER_NM")%></td>
                    <td width=10% align='center' height="20"><%=user.get("USER_POS")%></td>
                    <td width=8% align='center' height="20"><%=ab.getIp_chk()%></td>
                    <td width=13% align='center' height="20"> 
                      <%if(!ab.getLogin_dt().equals("")){
        			  		if(!ab.getTitle().equals("") || !ab.getContent().equals("")){
        			  %>
                      <a href="javascript:ScheDisp('<%=user_id%>','<%=s_year%>','<%=s_month%>','<%=s_day%>');"> 
                      <%		if(ab.getLogin_dt().equals("현지출근")){%><font color="red">
                      <%		}else if(ab.getLogin_dt().substring(0,2).equals("20")){%>
                      <%		}else{%>
                      <font color="blue">
                      <%		}%>
                      <%=ab.getLogin_dt()%> 
                      <%		if(ab.getLogin_dt().substring(0,2).equals("20")){%>
                      <%		}else{%>
                      </font>
                      <%		}%>
                      </a> 
                      <%	}else{%>
                      <%  		if ( AddUtil.parseLong( ab.getLogin_dt().substring(0,2) ) > 8  ) { %>
                       <a href="javascript:AttendReg('<%=user_id%>','<%=s_year%>','<%=s_month%>','<%=s_day%>');"> 
                      <%  		} %>
                      <%=ab.getLogin_dt()%> 
                      <%  		if ( AddUtil.parseLong( ab.getLogin_dt().substring(0,2) ) > 8  ) { %>
                      </a>
                       <%  		} %>
                      <%	}
        				}else{
        					if(!ab2.getTitle().equals("") || !ab2.getContent().equals("")){%>
                      <a href="javascript:ScheDisp('<%=user_id%>','<%=s_year%>','<%=s_month%>','<%=s_day%>');"> 
                      <%		if(ab2.getLogin_dt().equals("현지출근")){%><font color="red">
                      <%		}else if(ab2.getLogin_dt().substring(0,2).equals("20")){%>
                      <%		}else{%>
                      <font color="blue">
                      <%		}%>
                      <%=ab2.getLogin_dt()%> 
                      <%		if(ab2.getLogin_dt().substring(0,2).equals("20")){%>
                      <%		}else{%>
                      </font>
                      <%		}%>
                      </a> 
                      <%	}%>
                      <%}%>
                    </td>
                    <td width=32% align='left' height="20">&nbsp;
                    	<% if( !ab.getRemark().equals("")){ %>
        				<span title="<%= ab.getRemark() %>"><%= AddUtil.subData(ab.getRemark(),20) %></span>
        				<% } %>
        				<% if(ab.getTitle().equals("")){ %>
        					<span title="<%= ab2.getTitle() %>"><%= AddUtil.subData(ab2.getTitle(),20) %></span>
        				<% }else{ %>
        					<span title="<%= ab.getTitle() %>"><%= AddUtil.subData(ab.getTitle(),20) %></span>
        				<% } %>
        				
        				</td>
                </tr>
            <%}%>
            </table>
        </td>
<%	}else{	%>                     
    <tr>		
        <td class=line height="21"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
			        <td align='center'>등록된 데이타가 없습니다</td>
				</tr>
			</table>
		</td>		
	</tr>
<%	}%>
</table>
</form>