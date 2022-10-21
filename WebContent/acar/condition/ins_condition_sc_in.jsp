<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<jsp:useBean id="i_db" scope="page" class="acar.con_ins.InsurDatabase"/>
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
<%
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String ins_com = request.getParameter("ins_com")==null?"":request.getParameter("ins_com");
	String gubun = request.getParameter("gubun")==null?"1":request.getParameter("gubun");
	
	Vector stats = null;
	if(s_kd.equals("4"))	stats = i_db.getInsConStat(s_kd, ins_com, gubun);
	else					stats = i_db.getInsConStat(s_kd, t_wd, gubun);

	int stat_size = stats.size();
%>

<body onLoad="javascript:init()">
<table border=0 cellspacing=0 cellpadding='0' width='1300'>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td id='td_title' class=line style='position:relative;' width='55%'>
			<table border=0 cellspacing=1 cellpadding=0 width='100%'>
				<tr>
					<td width=8% class=title style='height:51'>연번</td>
            		<td width='15%' class='title' rowspan='2'>계약번호</td>
            		<td width='20%' class='title' rowspan='2'>상호</td>
            		<td width='14%' class='title' rowspan='2'>증서번호</td>
            		<td width='8%' class='title' rowspan='2'>에어백</td>
            		<td width='10%' class='title' rowspan='2'>가입연령</td>
            		<td width='13%' class='title' rowspan='2'>차량번호</td>
            		<td width='12%' class='title' rowspan='2'>보험사명</td>
            	</tr>
            </table>
		</td>
		<td class='line' width='45%'>			
            <table border=0 cellspacing=1 cellpadding=0 width='100%'>
                <tr>            		
                    <td class='title' colspan='3'>보험료</td>                    		
                    <td class='title' colspan='2'>계약기간</td>
                    <td width='10%' class='title' rowspan='2'>납입회차</td>                    		
                    <td width='10%' class='title' rowspan='2'>보험구분</td>
        	    </tr>
                <tr>
                    <td width='16%' class=title>책임보험료</td>
                    <td width='16%' class=title>종합보험료</td>
                    <td width='16%' class=title>총납부계</td>                    		
                    <td width='16%' class=title>계약개시일 </td>                    		
                    <td width='16%' class=title>계약만료일 </td>
            	</tr>				
			</table>
		</td>
	</tr>
<%
	if(stat_size > 0)
	{
%>
	<tr>
		<td id='td_con' class=line style='position:relative;' width='55%'>
			<table border=0 cellspacing=1 cellpadding='0' width='100%'>
<%
		for(int i = 0 ; i < stat_size ; i++)
		{
			Hashtable stat = (Hashtable)stats.elementAt(i);
%>            	
           		<tr>
           			<td align="center" width=8%><%= i+1%></td>
            		<td width='15%'  align='center'><%=stat.get("RENT_L_CD")%></td>
            		<td width='20%' align='center'><span title='<%=stat.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(stat.get("FIRM_NM")), 7)%></span></td>
            		<td width='14%' align='center'><span title='<%=stat.get("INS_CON_NO")%>'><%=Util.subData(String.valueOf(stat.get("INS_CON_NO")), 12)%></span></td>
            		<td width='8%'  align='center'><%if(String.valueOf(stat.get("AIR")).equals("0")){%>-<%}else{%><%=stat.get("AIR")%>개 <%}%></td>
            		<td width='10%' align='center'><%=stat.get("AGE")%></td>
            		<td width='13%' align='center'><span title='<%=stat.get("CAR_NO")%>'><%=stat.get("CAR_NO")%></span></td>
            		<td width='12%'  align='center'><span title='<%=stat.get("INS_COM_NM")%>'><%=Util.subData(String.valueOf(stat.get("INS_COM_NM")), 6)%></span></td>
            	</tr>
<%		}
%>
			</table>
		</td>
		<td class=line width='45%'>			
            <table border=0 cellspacing=1 cellpadding='0' width='100%'>
        <%
		for(int i = 0 ; i < stat_size ; i++)
		{
			Hashtable stat = (Hashtable)stats.elementAt(i);
%>
                <tr>
            		<td width='16%' align='right'><%=Util.parseDecimal(String.valueOf(stat.get("RINS_AMT")))%>원&nbsp;</td>
            		<td width='16%' align='right'><%=Util.parseDecimal(String.valueOf(stat.get("VINS_AMT")))%>원&nbsp;</td>
            		<td width='16%' align='right'><%=Util.parseDecimal(String.valueOf(stat.get("INS_AMT")))%>원&nbsp;</td>
            		
                    <td width='16%' align='center'><%=stat.get("INS_START_DT")%></td>
            		
                    <td width='16%' align='center'><%=stat.get("INS_EXP_DT")%></td>
            		<td width='10%' align='center'><%=stat.get("PAY_TM")%>회</td>
            		
                    <td align='center' width='10%'><%=stat.get("INS_STS")%></td>
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
		<td id='td_con' class=line style='position:relative;' width='55%'>
			<table border=0 cellspacing=1 cellpadding='0' width='680'>
				<tr>
					<td align='center'>등록된 데이타가 없습니다</td>
				</tr>
			</table>
		</td>
		<td width='45%' class='line'>
			<table border=0 cellspacing=1 cellpadding='0' width='585'>
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