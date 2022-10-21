<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_office.*, acar.common.*"%>
<%@ include file="/agent/cookies.jsp" %>
<%
	
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String dest_gubun = request.getParameter("dest_gubun")==null?"":request.getParameter("dest_gubun");	
	String rslt_dt = request.getParameter("rslt_dt")==null?"1":request.getParameter("rslt_dt");
	String st_dt = request.getParameter("st_dt")==null?"":AddUtil.ChangeString(request.getParameter("st_dt"));	
	String end_dt = request.getParameter("end_dt")==null?"":AddUtil.ChangeString(request.getParameter("end_dt"));
	String dest_nm = request.getParameter("dest_nm")==null?"":request.getParameter("dest_nm");	
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");	
	
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();	
	
	dest_gubun = "";
	
	Vector resultList = umd.getSmsResult2(gubun, dest_gubun, rslt_dt, st_dt, end_dt, dest_nm, sort, sort_gubun);
	
	Vector resultList2 = umd.getSmsResult2_V5(gubun, dest_gubun, rslt_dt, st_dt, end_dt, dest_nm, sort, sort_gubun);
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
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
	
	var checkflag = "false";
	function AllSelect(field){
		if(checkflag == "false"){
			for(i=0; i<field.length; i++){
				field[i].checked = true;
			}
			checkflag = "true";
			return;
		}else{
			for(i=0; i<field.length; i++){
				field[i].checked = false;
			}
			checkflag = "false";
			return;
		}
	}
-->
</script>
</head>
<body onLoad="javascript:init()">
<form name="form1">
<table border=0 cellspacing=0 cellpadding=0 width=1400>
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>문자발송내역</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
	<tr>
		<td>
		    <table border="0" cellspacing="0" cellpadding="0" width="100%">
		        <tr>
		            <td class=line2 colspan=2></td>
		        </tr>
			    <tr id='tr_title' style='position:relative;z-index:1'>		
				    <td class='line' id='td_title' style='position:relative;' width=25%> 
				        <table border="0" cellspacing="1" cellpadding="0" width="100%">
        					<tr> 
        					    <td width=15% class='title'>연번</td>
        					    <td width=25% class='title'>대상</td>                  
        					    <td width=25% class='title'>수신자명</td>
        					    <td width=35% class='title'>수신자번호</td>
        					</tr>
				        </table>
				    </td>		
				    <td class='line' width=75%> 
				        <table border="0" cellspacing="1" cellpadding="0" width="100%">
					        <tr>
        					    <td width=37% class='title'>문자내용</td>
        					    <td width=10% class='title'>회신번호</td>				  
        					    <td width=9% class='title'>발신자명</td>
        					    <td width=14% class='title'>전송시간</td>
        					    <td width=14% class='title'>도착시간</td>
        					    <td width=7% class='title'>처리상태</td>
        					    <td width=9% class='title'>전송결과</td>
					        </tr>
				        </table>
				    </td>
			    </tr>
			    <%if(resultList.size()+resultList2.size() !=0 ){%>
			    <tr>
				    <td class='line' id='td_con' style='position:relative;' width=25%> 
				        <table border="0" cellspacing="1" cellpadding="0" width="100%" >
					<% for(int i=0; i< resultList2.size(); i++){
						Hashtable ht = (Hashtable)resultList2.elementAt(i);
					%>
					        <tr> 
        					    <td width=15% align='center'><%=i+1%></td>
        					    <td width=25% align='center'></td>
        					    <td width=25% align="center"><%= ht.get("DEST_NAME") %></td>
        					    <td width=35% align='center'><%= ht.get("DEST_PHONE")%></td>                  
					        </tr>
					<%}%>						
					<% for(int i=0; i< resultList.size(); i++){
						Hashtable ht = (Hashtable)resultList.elementAt(i);
						String etc2 = (String)ht.get("ETC2");
					%>
					        <tr> 
        					    <td width=15% align='center'><%=resultList2.size()+i+1%></td>
        					    <td width=25% align='center'><% if(etc2.equals("1"))	out.print("영업사원");
        														else if(etc2.equals("2"))	out.print("계약자");
        														else if(etc2.equals("3"))	out.print("당사직원");	 %></td>
        					    <td width=25% align="center"><%= ht.get("DESTNAME") %></td>
        					    <td width=35% align='center'><%= ht.get("DESTPHONE")%></td>                  
					        </tr>
					<%}%>

				        </table>
				    </td>
				    <td class='line' width=75%> 
				        <table border="0" cellspacing="1" cellpadding="0" width="100%" >
					<% for(int i=0; i< resultList2.size(); i++){
							Hashtable ht = (Hashtable)resultList2.elementAt(i);
							String status = (String)ht.get("STATUS");
							String rslt  =  (String)ht.get("CALL_RESULT");
					%>
					        <tr> 
        						<td width=37% align='' >&nbsp;<span title="<%= ht.get("MSG_BODY") %>"><%= AddUtil.subData((String)ht.get("MSG_BODY"),30) %></span></td>
        						<td width=10% align='center' ><%= ht.get("SEND_PHONE") %></td>
        						<td width=9% align='center' ><%= c_db.getNameById((String)ht.get("SEND_NAME"), "USER") %></td>
        						<td width=14% align='center' ><%= AddUtil.ChangeDate3((String)ht.get("SEND_TIME")) %></td>
        						<td width=14% align='center'><%= AddUtil.ChangeDate3((String)ht.get("REPORT_TIME")) %></td>			
        						<td width=7% align='center' ><% if(status.equals("0")) out.print("전송요구");
        														else if(status.equals("1")) out.print("전송후결과대기중");
        														else if(status.equals("2")) out.print("결과받음");
        														else if(status.equals("3")) out.print("전송실패");  %></td>
        						<td width=9% align='center'><% if(rslt.equals("4100")) out.print("전달!");
        														else if(rslt.equals("4400")) out.print("음영지역");
        														else if(rslt.equals("4410")) out.print("잘못된전화번호");
        														else if(rslt.equals("4420")) out.print("기타에러");
        														else if(rslt.equals("4430")) out.print("수신거부"); %></td>
						    </tr>
					 <%}%>								
					<% for(int i=0; i< resultList.size(); i++){
							Hashtable ht = (Hashtable)resultList.elementAt(i);
							String status = (String)ht.get("STATUS");
							String rslt  =  (String)ht.get("RSLT");
					%>
					        <tr> 
        						<td width=37% align='' >&nbsp;<span title="<%= ht.get("MSG") %>"><%= AddUtil.subData((String)ht.get("MSG"),30) %></span></td>
        						<td width=10% align='center' ><%= ht.get("SENDPHONE") %></td>
        						<td width=9% align='center' ><%= c_db.getNameById((String)ht.get("SENDNAME"), "USER") %></td>
        						<td width=14% align='center' ><%= AddUtil.ChangeDate3((String)ht.get("SENDDATE")) %></td>
        						<td width=14% align='center'><%= AddUtil.ChangeDate3((String)ht.get("RSLTDATE")) %></td>			
        						<td width=7% align='center' ><% if(status.equals("0")) out.print("전송요구");
        														else if(status.equals("1")) out.print("전송후결과대기중");
        														else if(status.equals("2")) out.print("결과받음");
        														else if(status.equals("3")) out.print("전송실패");  %></td>
        						<td width=9% align='center'><% if(rslt.equals("0")) out.print("성공!");
        														else if(rslt.equals("1")) out.print("기타에러");
        														else if(rslt.equals("2")) out.print("번호없음");
        														else if(rslt.equals("3")) out.print("음영지역");
        														else if(rslt.equals("4")) out.print("시스템장애");
        														else if(rslt.equals("5")) out.print("인증실패");
        														else if(rslt.equals("6")) out.print("메세지형식오류"); %></td>
						    </tr>
					 <%}%>			 
					    </table>
				    </td>
			    </tr>
			    <%}else{%>
			    <tr>
				    <td class='line' id='td_con' style='position:relative;' width=25%> 
				        <table border="0" cellspacing="1" cellpadding="0" width="100%" >
        					<tr> 
        					    <td align='center'></td>
        					</tr>
				        </table>
				    </td>
				    <td class='line' width=75%> 
				        <table border="0" cellspacing="1" cellpadding="0" width="100%" >
        				    <tr> 
        					    <td  align='left' >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;해당 데이터가 없읍니다.</td>
        				    </tr>          
				        </table>
				    </td>
			    </tr>
			<%}%>		
			</table>
		</td>
	</tr>
</table>
</form>
</body>
</html>