<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.condition.*" %>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>

<%
	ConditionDatabase cdb = ConditionDatabase.getInstance();

	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String brch_id 	= request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String s_bank 	= request.getParameter("s_bank")==null?"":request.getParameter("s_bank");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String g_fm	 	= request.getParameter("g_fm")==null?"":request.getParameter("g_fm");
	String dt		= request.getParameter("dt")==null?"":request.getParameter("dt");
	String ref_dt1 	= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 	= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String sort 	= request.getParameter("sort")==null?gubun2:request.getParameter("sort");
	
	Vector cars = al_db.getClientMgrEmailList(dt, gubun2, gubun3, gubun4, gubun5, sort);
	int car_size = cars.size();	
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link><script language="JavaScript">
<!--
/* Title 고정 */
function setupEvents()
{
		window.onscroll = moveTitle ;
		window.onresize = moveTitle ; 
}

function moveTitle()
{
    var X ;
    document.all.title.style.pixelTop = document.body.scrollTop ;
                                                                              
    document.all.title_col0.style.pixelLeft	= document.body.scrollLeft ; 
    document.all.D1_col.style.pixelLeft	= document.body.scrollLeft ;   
    
}
function init() {
	
	setupEvents();
}
	function open_client_email(client_id){
		var SUBWIN="/acar/mng_client2/client_email.jsp?client_id="+client_id;	
		window.open(SUBWIN, "MailUp", "left=10, top=100, width=1024, height=600, scrollbars=yes, status=yes");	
	}
	function open_caremp_mail(emp_nm){
		var SUBWIN="/acar/car_office/caremp_email.jsp?t_wd="+emp_nm;	
		window.open(SUBWIN, "MailUp", "left=3, top=50, width=1000, height=600, scrollbars=yes");
	}		
//-->
</script>
</head>
<body onLoad="javascript:init()">
<form name='form1' method='post' target='d_content' action='/acar/car_rent/con_reg_frame.jsp'>
<table border=0 cellspacing=0 cellpadding=0 width="100%">
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td>
            <table border=0 cellspacing=0 cellpadding=0 width="100%">
                <tr id='title' style='position:relative;z-index:1'>            		
                    <td width=40% class=line id='title_col0' style='position:relative;'> 
	  		            <table border=0 cellspacing=1 width="100%">
                            <tr> 
                                <td width=8% class=title >연번</td>
                                <td width=24% class=title>상호</td>
                                <td width=24% class=title>차량번호</td>
                                <td width=24% class=title>차명</td>
                                <td width=20% class=title>구분</td>
                            </tr>
                        </table>
		            </td>
		            <td class=line width=60%>
			            <table  border=0 cellspacing=1 width="100%">
                            <tr>
                                <td width=31% class=title>소속/부서</td>
                                <td width=14% class=title>성명</td>
                                <td width=15% class=title>직위</td>
                                <td width=28% class=title>이메일</td>
                                <td width=12% class=title>수신거부</td>
                            </tr>
                        </table>
		            </td>
		        </tr>
<%	if(car_size != 0){ %>
                <tr>            		
                    <td width=40% class=line id='D1_col' style='position:relative;'> 
		                <table border=0 cellspacing=1 width=100%>
<%		for(int i = 0 ; i < car_size ; i++){
			Hashtable car = (Hashtable)cars.elementAt(i);%>
                            <tr> 
                                <td align="center" width=8%><%= i+1%></td>
                                <td align="center" width=24%><span title="<%=car.get("FIRM_NM")%>"><%= Util.subData(String.valueOf(car.get("FIRM_NM")),5) %></span></td>
                                <td align="center" width=24%><%=car.get("CAR_NO")%></td>
                                <td align="center" width=24%><span title="<%=car.get("CAR_NM")%>"><%= Util.subData(String.valueOf(car.get("CAR_NM")),5) %></span></td>
                                <td align="center" width=20%><%=car.get("GUBUN")%></td>
                            </tr>
<%		}%>
                        </table>
		            </td>            		            		
                    <td width=60% class=line>
                        <table border=0 cellspacing=1 width=100%>
<%		int  t_cnt[] = new int[17];
		for(int i = 0 ; i < car_size ; i++){
			Hashtable car = (Hashtable)cars.elementAt(i);
			t_cnt[0] += AddUtil.parseInt(String.valueOf(car.get("CONT_CNT")));
			%>
                            <tr> 
                                <td width=31% align="center"><span title="<%=car.get("DEPT")%>"><%= Util.subData(String.valueOf(car.get("DEPT")),12) %></span></td>
                                <td width=14% align="center">
                				<%if(String.valueOf(car.get("ST")).equals("MGR")){%>
                				<a href="javascript:open_client_email('<%=car.get("CLIENT_ID")%>')"><%=car.get("NAME")%></a>
                				<%}else{%>
                				<a href="javascript:open_caremp_mail('<%=car.get("NAME")%>')"><%=car.get("NAME")%></a>
                				<%}%>
                				</td>
                                <td width=15% align="center"><span title="<%=car.get("TITLE")%>"><%= Util.subData(String.valueOf(car.get("TITLE")),4) %></span></td>
                                <td width=28% align="center"><span title="<%=car.get("EMAIL")%>"><%= Util.subData(String.valueOf(car.get("EMAIL")),18) %></span></td>
                                <td width=12% align="center"><%=car.get("EMAIL_YN")%></td>
                            </tr>
<%		}%>
                        </table>
		            </td>            		            		
                </tr>
<%	}else{%>
	            <tr>            		
                    <td width=40% class=line id='D1_col' style='position:relative;'> 
		                <table border=0 cellspacing=1 width=100%>
                            <tr> 
                                <td align="center" width=150></td>
                            </tr>
                        </table>
		            </td>            		            		
                    <td width=60% class=line>
                        <table border=0 cellspacing=1 width=100%>
			                <tr>
				                <td> &nbsp;등록된 데이타가 없습니다.</td>
			                </tr>
		                </table>
		            </td>            		            		
                </tr>
<%	}%>
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>