<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.attend.*, acar.schedule.*" %>
<jsp:useBean id="calendar" class="acar.car_sche.CalendarBean" scope="page"/>
<jsp:useBean id="aa_db" scope="page" class="acar.attend.AttendDatabase"/>
<jsp:useBean id="bean" class="acar.attend.AttendBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
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
		
	String user_id  = "";
	
		
%>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href=../../include/table_t.css>
<style type="text/css">
td.sat 			{ font-family:굴림, Gulim, AppleGothic, Seoul, Arial; background-color:#EEF5F9; font-size:9pt; color:black; height:25; vertical-align:middle;}
td.sun 			{ font-family:굴림, Gulim, AppleGothic, Seoul, Arial; background-color:#FEE6E6; font-size:9pt; color:black; height:25; vertical-align:middle;}
</style>
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
		var url = "?mode=view&auth_rw=<%=auth_rw%>&user_id=" + user_id
				+ "&start_year=" + year 
				+ "&start_mon=" + mon
				+ "&start_day=" + day;
		var SUBWIN="sch_c.jsp" + url;		
		window.open(SUBWIN, "SchDisp", "left=100, top=100, width=720, height=400, scrollbars=yes");
	}	
	
	function AttendReg(user_id, year, mon, day){
		var theForm = document.thefrm;
		var url = "?auth_rw=<%=auth_rw%>&user_id=" + user_id
				+ "&start_year=" + year 
				+ "&start_mon=" + mon
				+ "&start_day=" + day;
		var SUBWIN="sch_reason_i.jsp" + url;		
		window.open(SUBWIN, "SchDisp", "left=100, top=100, width=720, height=400, scrollbars=yes");
	}	
//-->
</script>
</head>
<body>

<form name='form1' target='MAPPING' method="POST">
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
    
     <%for(int i = 0 ; i < user_size ; i++){
				Hashtable user = (Hashtable)users.elementAt(i);
			
    		   user_id = String.valueOf(user.get("USER_ID"));		
    		   
    		   String avg_dt = aa_db.getAvgAttendDate(user_id, s_year , AddUtil.addZero(s_month) );
    		   
    		   	%>
    		   
    <tr>		
        <td class=line>	
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>            
                <tr align="center"> 
                    <td width=3% class='title'>연번</td>
                    <td width=8% class='title'>날짜</td>
                    <td width=8% class='title'>구분</td>
                    <td width=13% class='title'>로그인시간 (평균:  <%=avg_dt %> )</td>
                    <td width=32% class='title'>적요</td>
                </tr>
           
            </table>
		</td>
	</tr>

  
				
	<tr>
		<td class=line>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
           	<%	for(int l=1; l<=days ; l++){
    					AttendBean ab = aa_db.getAttendUserDay(user_id, s_year, AddUtil.addZero(s_month), AddUtil.addZero2(l));
    					AttendBean ab2 = new AttendBean();
    					if(ab.getLogin_dt().equals("")){//로그인 없으면
    						ab2 = aa_db.getAttendUserPrv(user_id, s_year, AddUtil.addZero(s_month), AddUtil.addZero2(l));
    					}
    					int day_of_week = calendar.getDayOfWeek(AddUtil.parseInt(s_year), AddUtil.parseInt(s_month), l);
    					String td_color = "";//평일
    					if(day_of_week == 1)			td_color = "class='sun'"; //일요일
    					else if(day_of_week == 7)	td_color = "class='sat'"; //토요일  
    				%>
    					
                <tr>                
                    <td align='center' width=3% <%=td_color%> height="20">  <%=l%></td>
                    <td width=8% align='center' height="20"  <%=td_color%>>
                    	<%= s_year%>-<%=AddUtil.addZero(s_month)%>-<%= AddUtil.addZero2(l)%>&nbsp; 
                      <% if ( day_of_week == 1)  {%> (일)
                      <% } else if  ( day_of_week == 2)  {%> (월)
                      <% } else if  ( day_of_week == 3)  {%> (화)
                      <% } else if  ( day_of_week == 4)  {%> (수)
                      <% } else if  ( day_of_week == 5)  {%> (목)
                      <% } else if  ( day_of_week == 6)  {%> (금)
                      <% } else if  ( day_of_week == 7)  {%> (토)
                      <% } %>
                    </td>
                    <td width=8% align='center' height="20"  <%=td_color%>><%=ab.getIp_chk()%></td>
                    <td width=13% align='center' height="20" <%=td_color%>>
                      <%
                      	String nnn = aa_db.getHoliday(s_year+AddUtil.addZero(s_month)+AddUtil.addZero2(l));
                      %>
                      <!--공휴일-->
                      <%if ( !nnn.equals("") ) {%>
                        &nbsp;<font color="#FF0000"><%=nnn%></font>&nbsp;
                      <%}else{ %>      
	                    <%  if(!ab.getLogin_dt().equals("")){
	                          //업무일지 등록
                            if(!ab.getTitle().equals("") || !ab.getContent().equals("")){%>
	                            <a href="javascript:ScheDisp('<%=user_id%>','<%=s_year%>','<%=s_month%>','<%=AddUtil.addZero2(l)%>');">  
	                    <%      if(ab.getLogin_dt().equals("현지출근")){%><font color="red">
	                    <%      }else if(ab.getLogin_dt().substring(0,2).equals("20")){%>
	                    <%      }else{%><font color="blue">
	                    <%      }%>
	                                 <%=ab.getLogin_dt()%> 
	                    <%			if(ab.getLogin_dt().substring(0,2).equals("20")){%>
	                    <%			}else{%></font>
	                    <%			}%>
	                          </a> 
	                          
	                      <%	}else{%>
	                      <%    if (td_color.equals("") && AddUtil.parseLong( ab.getLogin_dt().substring(0,2) ) > 8  ) { //9시이후%>
	                            <a href="javascript:AttendReg('<%=user_id%>','<%=s_year%>','<%=s_month%>','<%=AddUtil.addZero2(l)%>');">  
	                      <%  	} %>
	                      <%=ab.getLogin_dt()%> 
	                      <%    if (td_color.equals("") && AddUtil.parseLong( ab.getLogin_dt().substring(0,2) ) > 8  ) { %>
	                            </a>
	                       <%  	} %>
	                      <%	}
	        					}else{
	        						if(!ab2.getTitle().equals("") || !ab2.getContent().equals("")){%>
	            			    <a href="javascript:ScheDisp('<%=user_id%>','<%=s_year%>','<%=s_month%>','<%=AddUtil.addZero2(l)%>');">  
	                      <%			if(ab2.getLogin_dt().equals("현지출근")){%><font color="red">
	                      <%			}else if(ab2.getLogin_dt().substring(0,2).equals("20")){%>
	                      <%			}else{%>
	                      <font color="blue">
	                      <%			}%>
	                      <%=ab2.getLogin_dt()%> 
	                      <%			if(ab2.getLogin_dt().substring(0,2).equals("20")){%>
	                      <%			}else{%>
	                      </font>
	                      <%			}%>
	                      </a> 
	                      <%		}
	        			  		}%>
	        			  <% } %>		
                    </td>
                    <td width=32% align='left'  height="20"  <%=td_color%>>&nbsp;
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
     </tr>
<%	}%>     
</table>
</form>