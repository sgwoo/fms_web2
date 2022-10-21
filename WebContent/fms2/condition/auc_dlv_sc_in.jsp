<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>

<jsp:useBean id="auction" scope="page" class="acar.offls_actn.Offls_auctionBean"/>
<jsp:useBean id="olaD" class="acar.offls_actn.Offls_actnDatabase" scope="page"/>

<%
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String dt = request.getParameter("dt")==null?"0":request.getParameter("dt");
	String t_st_dt = request.getParameter("t_st_dt")==null?"":request.getParameter("t_st_dt");
	String t_end_dt = request.getParameter("t_end_dt")==null?"":request.getParameter("t_end_dt");
	
	Vector stats = new Vector();
	stats = olaD.getAucPurDlvStats(s_kd, t_wd, dt, t_st_dt, t_end_dt);
	int stat_size = stats.size();
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel='stylesheet' type='text/css' href='../../include/table_t.css'>
<script language='javascript'>
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
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    
	    
	}
	function init() {
		
		setupEvents();
	}
-->
</script>
</head>
<body onLoad="javascript:init()">
<table border=0 cellspacing=0 cellpadding='0' width='1160'>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td id='td_title' class=line style='position:relative;' width='560'>
			<table border=0 cellspacing=1 cellpadding=0 width='100%'>
				<tr>
					<td class='title' width='10%'>연번</td>
					<td class='title' width='15%'>경매일</td>
					<td class='title' width='10%'>구분</td>
					<td class='title' width='25%'>경매장</td>
			 		<td class='title' width='25%'>매각차종</td>
            		<td class='title' width='15%'>매각차량번호</td>            		
            		
            	</tr>
            </table>
		</td>
		<td class='line' width='600'>
			<table border=0 cellspacing=1 cellpadding=0 width='100%'>
				<tr>
					<td class='title' width='18%'>계출번호</td>					
            		<td class='title' width='15%'>출고차량번호</td>
            		<td class='title' width='17%'>출고차종</td>
            		<td class='title' width='15%'>출고일</td>            	           						
            		<td class='title' width='25%'>출고지점</td>
            		<td class='title' width='15%'>관리자</td>
				</tr>
			</table>
		</td>
	</tr>
<%
	if(stat_size > 0)
	{
%>
	<tr>
		<td id='td_con' class=line style='position:relative;' width='560'>
			<table border=0 cellspacing=1 cellpadding='0' width='100%'>
<%
		for(int i = 0 ; i < stat_size ; i++)
		{
			Hashtable stat = (Hashtable)stats.elementAt(i);
%>            	
           		<tr>
           			<td align='center' width='10%'><%=i+1%></td>
           			<td align='CENTER' width='15%'><%=stat.get("ACTN_DT")%></td>
					<td align='CENTER' width='10%'><%=stat.get("SEQ")%>차</td>
           			<td align='CENTER' width='25%'><%=stat.get("FIRM_NM")%>&nbsp;<%=stat.get("ACTN_WH")%></td>
					<td align='CENTER' width='25%'><%=stat.get("ACN_CAR_NM")%></td>
            		<td align='CENTER' width='15%'><%=stat.get("ACN_CAR_NO")%></td>
            		
            		
            	</tr>
<%		}
%>
			</table>
		</td>
		<td class=line width='600'>
			<table border=0 cellspacing=1 cellpadding='0' width='100%'>
<%
		for(int i = 0 ; i < stat_size ; i++)
		{
			Hashtable stat = (Hashtable)stats.elementAt(i);
%>            				
				<tr>
				    <td align='center' width='18%'><%=stat.get("RPT_NO")%></td>	
				    <td align='center' width='15%'><%=stat.get("CAR_NO")%></td>       
				    <td align='center' width='17%'><%=stat.get("CAR_NM")%></td>                        
            	    <td align='center' width='15%'><%=stat.get("DLV_DT")%></td>            	             
                    <td align='center' width='25%'><%=stat.get("CAR_OFF_NM")%></span></td>
            	    <td align='center' width='15%'><%=stat.get("EMP_NM")%></td>
           		</tr>
<%
		}
%>
			</table>
		</td>
	</tr>
<%
	}
	else
	{
%>
	<tr>
		<td id='td_con' class=line style='position:relative;' width='560'>
			<table border=0 cellspacing=1 cellpadding='0' width='100%'>
				<tr>
					<td align='center'>등록된 데이타가 없습니다</td>
				</tr>
			</table>
		</td>
		<td width='600' class='line'>
			<table border=0 cellspacing=1 cellpadding='0' width='100%'>
				<tr>
					<td>&nbsp;</td>
				</tr>
			</table>
		</td>		
	</tr>
<%
	}
%>
</table>
</body>
</html>