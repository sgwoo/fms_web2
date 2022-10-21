<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>

<jsp:useBean id="olaD" class="acar.offls_actn.Offls_actnDatabase" scope="page"/>

<%
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String dt = request.getParameter("dt")==null?"actn_dt":request.getParameter("dt");
	
	String s_year 	= request.getParameter("s_year")==null?"":request.getParameter("s_year");
	
	
	Vector stats = new Vector();
	stats = olaD.getAucPurMonLists(s_kd, t_wd, dt,s_year);
	int stat_size = stats.size();
	
	long t_cnt = 0;
	long y_cnt = 0;
	long c_cnt = 0;
	long c_amt = 0;
	long c_amt_top = 0;
	long c_amt_l = 0;
	
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
<body>
<table border=0 cellspacing=0 cellpadding='0' width='950'>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
	<tr>
		  <td class=line> 
			<table border=0 cellspacing=1 cellpadding=0 width='100%'>
				<tr>
					<td class='title' width='200' rowspan=2 style='height:45'>구분</td>
					<td class='title' width='150' rowspan=2>출품실적</td>
					<td class='title' width='150' rowspan=2>낙찰실적</td>
					<td class='title' colspan=3 >출품수수료</td>            		
            	</tr>
            	<tr>					
					<td class='title' width='150' >건수</td>
					<td class='title' width='150' >금액</td>
					<td class='title' width='150' >최종금액(금액*0.75*1.1)</td>		
            	</tr>
            </table>
		</td>
	
	</tr>
<%
	if(stat_size > 0)
	{
%>
	<tr>
		<td  class=line style='position:relative;' width='950'>
			<table border=0 cellspacing=1 cellpadding='0' width='100%'>
<%
		for(int i = 0 ; i < stat_size ; i++)
		{
			Hashtable stat = (Hashtable)stats.elementAt(i);
			
			t_cnt += AddUtil.parseLong(String.valueOf(stat.get("T_CNT")));  
			y_cnt += AddUtil.parseLong(String.valueOf(stat.get("Y_CNT")));  
			c_cnt += AddUtil.parseLong(String.valueOf(stat.get("C_CNT")));  
			c_amt += AddUtil.parseLong(String.valueOf(stat.get("C_AMT")));  

			c_amt_top += AddUtil.parseLong(String.valueOf(stat.get("C_AMT_L")));  
%>            	
           		<tr>         			
           		    <td align='CENTER' width='200'><a href="javascript:parent.view_actn('<%=s_kd%>', '<%=t_wd%>', '<%=dt%>', '<%=s_year%>', '<%=stat.get("MON")%>')"><%=stat.get("MON")%>&nbsp;월</a></td>
           			<td align='CENTER'  width='150'><%=Util.parseDecimal(String.valueOf(stat.get("T_CNT")))%></td> 
           			<td align='CENTER'  width='150'><%=Util.parseDecimal(String.valueOf(stat.get("Y_CNT")))%></td>   
           			<td align='CENTER'  width='150'><%=Util.parseDecimal(String.valueOf(stat.get("C_CNT")))%></td>  
           			<td align='right'  width='150'><%=Util.parseDecimal(String.valueOf(stat.get("C_AMT")))%></td>   
           		     <td align='right'  width='150'><%=Util.parseDecimal(String.valueOf(stat.get("C_AMT_L")))%></td>   		         		            		
            	</tr>
<%		}
   
%>
				 <tr> 
		            <td class=title align="center">합계</td>
		            <td class=title><%=Util.parseDecimal(t_cnt)%></td>
		            <td class=title><%=Util.parseDecimal(y_cnt)%></td>
		            <td class=title><%=Util.parseDecimal(c_cnt)%></td>
		            <td class=title style="text-align:right"><%=Util.parseDecimal(c_amt)%></td>
					<td class=title style="text-align:right"><%=Util.parseDecimal(c_amt_top)%></td>
		          </tr>	
			</table>
		</td>
	
	</tr>
<%
	}
	else
	{
%>
	<tr>
		<td id='td_con' class=line style='position:relative;' width='950'>
			<table border=0 cellspacing=1 cellpadding='0' width='100%'>
				<tr>
					<td align='center'>등록된 데이타가 없습니다</td>
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