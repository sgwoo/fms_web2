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
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/index.css">
</head>
<body onLoad="javascript:init()">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
//	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");	
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");	
	String s_year = request.getParameter("s_year")==null?"":request.getParameter("s_year");	
	String s_month = request.getParameter("s_month")==null?"":request.getParameter("s_month");	
	int days = AddUtil.getMonthDate(Integer.parseInt(s_year), Integer.parseInt(s_month));
	
	Vector users = aa_db.getAttendUser2(s_kd, t_wd);
	int user_size = users.size();
%>
<form name='form1' action='bank_mapping_i.jsp' target='MAPPING' method="POST">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="s_kd" value="<%=s_kd%>">
<input type="hidden" name="t_wd" value="<%=t_wd%>">
<input type="hidden" name="s_year" value="<%=s_year%>">
<input type="hidden" name="s_month" value="<%=s_month%>">
<table border="0" cellspacing="0" cellpadding="0" width=<%=300+130*days%>>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>		
        <td bgcolor=#7A9494 class=line width='300' id='td_title' style='position:relative;'>	
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td colspan="5" class='title1'>&nbsp;</td>
                </tr>
                <tr> 
                    <td width=10% class='title1'>연번</td>
                    <td width=20% class='title1'>근무지</td>
                    <td width=25% class='title1'>부서</td>
                    <td width=20% class='title1'>이름</td>
                    <td width=25% class='title1'>직위</td>
                </tr>
                <tr> 
                    <td colspan="5" class='title1'>&nbsp;<font color="#FF0000"><%=aa_db.getHoliday(AddUtil.getDate(4))%></font>&nbsp;</td>
                </tr>
            </table>
        </td>
		<td class=line width='<%=130*days%>'>			
            <table border="0" cellspacing="1" cellpadding="0" width=<%=130*days%>>
                <tr> 
                    <%for(int j=0; j<days ; j++){%>
                    <td colspan="2" class='title1'><%=s_month%>월 
                    <%=j+1%>일</td>
                    <%}%>
                </tr>
                <tr> 
                    <%for(int k=0; k<days ; k++){%>
                    <td class='title1' width="80">로그인시간</td>
                    <td class='title1' width="40">구분</td>
                    <%}%>
                </tr>
                <tr bgcolor=#FFFEEE align="center"> 
                    <%for(int h=0; h<days ; h++){%>
                    <td colspan="2" class='title1'>&nbsp;<font color="#FF0000"><%=aa_db.getHoliday(s_year+AddUtil.addZero(s_month)+AddUtil.addZero2(h+1))%></font>&nbsp;</td>
                    <%}%>
                </tr>		  
            </table>
		</td>
	</tr>
<%	if(user_size > 0){	%>
	<tr>		
        <td class=line width='300' id='td_con' style='position:relative;'>	
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
            <%for(int i = 0 ; i < user_size ; i++){
				Hashtable user = (Hashtable)users.elementAt(i);%>
                <tr bgcolor="#FFFFFF"> 
                    <td width=10% align='center' height="20"><%=i+1%></td>
                    <td width=20% align='center' height="20"><%=user.get("BR_NM")%></td>
                    <td width=25% align='center' height="20"><%=user.get("DEPT_NM")%></td>
                    <td width=20% align='center' height="20"><span title='<%=user.get("USER_NM")%>'><%=AddUtil.subData(String.valueOf(user.get("USER_NM")),3)%></span></td>
                    <td width=25% align='center' height="20"><%=user.get("USER_POS")%></td>
                </tr>
                <%}%>
            </table>
        </td>
		<td class=line width='<%=130*days%>'>			
            <table border="0" cellspacing="1" cellpadding="0" width=<%=130*days%>>
            <%for(int i = 0 ; i < user_size ; i++){
				Hashtable user = (Hashtable)users.elementAt(i);
				String user_id = String.valueOf(user.get("USER_ID"));%>
                <tr> 
      		  	<%	for(int l=1; l<=days ; l++){
    					AttendBean ab = aa_db.getAttendUserDay(user_id, s_year, AddUtil.addZero(s_month), AddUtil.addZero2(l));
    					AttendBean ab2 = new AttendBean();
    					if(ab.getLogin_dt().equals("")){//로그인 없으면
    						ab2 = aa_db.getAttendUserPrv(user_id, s_year, AddUtil.addZero(s_month), AddUtil.addZero2(l));
    					}
    					int day_of_week = calendar.getDayOfWeek(AddUtil.parseInt(s_year), AddUtil.parseInt(s_month), l);
    					String td_color = "#FFFFFF";//평일
    					if(day_of_week == 1)		td_color = "#FEE6E6"; //일요일
    					else if(day_of_week == 7)	td_color = "#EEF5F9"; //토요일%>
                    <td align='center' width='80' bgcolor=<%=td_color%> height="20"> 
                    <%	if(!ab.getLogin_dt().equals("")){
						if(!ab.getTitle().equals("") || !ab.getContent().equals("")){%>
                      <a href="javascript:ScheDisp('<%=user_id%>','<%=s_year%>','<%=AddUtil.addZero(s_month)%>','<%=AddUtil.addZero2(l)%>');">
        			  <%			if(ab.getLogin_dt().equals("현지출근")){%><font color="red"><%}else if(ab.getLogin_dt().substring(0,2).equals("20")){%><%}else{%><font color="blue"><%}%>   
        			    <%=ab.getLogin_dt()%>
        			  <%			if(ab.getLogin_dt().substring(0,2).equals("20")){%><%}else{%></font><%}%>   
        			  </a> 
                      <%		}else{%>
                      <%=ab.getLogin_dt()%> 
                      <%		}
        					}else{
        						if(!ab2.getTitle().equals("") || !ab2.getContent().equals("")){%>
                      <a href="javascript:ScheDisp('<%=user_id%>','<%=s_year%>','<%=AddUtil.addZero(s_month)%>','<%=AddUtil.addZero2(l)%>');">
        			  <%			if(ab2.getLogin_dt().equals("현지출근")){%><font color="red"><%}else if(ab2.getLogin_dt().substring(0,2).equals("20")){%><%}else{%><font color="blue"><%}%>   
        			  <%=ab2.getLogin_dt()%>
        			  <%			if(ab2.getLogin_dt().substring(0,2).equals("20")){%><%}else{%></font><%}%>   			  
        			  </a> 
                      <%		}else{%>
                      <%=ab2.getLogin_dt()%> 
                      <%		}
        			  		}%>
                    </td>
                    <td align='center' width='40' bgcolor=<%=td_color%> height="20"><%=ab.getIp_chk()%></td>
        			<%	}%>
                </tr>
                <%}%>
            </table>
		</td>
<%	}else{	%>                     
	<tr>		
        <td class=line width='300' id='td_con' style='position:relative;' height="21"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr bgcolor="#FFFFFF"> 
                    <td align='center'>등록된 데이타가 없습니다</td>
                </tr>
            </table>
        </td>		
        <td class=line width='<%=130*days%>'> 
            <table border="0" cellspacing="1" cellpadding="0" width='<%=130*days%>'>
                <tr bgcolor="#FFFFFF">					
                    <td>&nbsp;</td>
				</tr>
			</table>		
        </td>
	</tr>
<%	}%>
</table>
</form>