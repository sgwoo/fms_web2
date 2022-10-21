<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String dt = request.getParameter("dt")==null?"0":request.getParameter("dt");
	String t_st_dt = request.getParameter("t_st_dt")==null?"":request.getParameter("t_st_dt");
	String t_end_dt = request.getParameter("t_end_dt")==null?"":request.getParameter("t_end_dt");
	
	Vector stats = new Vector();
	stats = a_db.getDlvStats(s_kd, t_wd, "9",t_st_dt, t_end_dt);
	int stat_size = stats.size();
	
	long total_amt1	= 0;
	long total_amt2 = 0;
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
<table border=0 cellspacing=0 cellpadding='0' width='1740'>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td id='td_title' class=line style='position:relative;' width='480'>
			<table border=0 cellspacing=1 cellpadding=0 width='100%'>
				<tr>
					<td class='title' width='10%'>연번</td>
					<td class='title' width='25%'>계약번호</td>
					<td class='title' width='19%'>계약일</td>
					<td class='title' width='29%'>상호</td>
            		<td class='title' width='20%'>차종</td>
            		
            		
            	</tr>
            </table>
		</td>
		<td class='line' width='1260'>
			<table border=0 cellspacing=1 cellpadding=0 width='100%'>
				<tr>            		
            		<td class='title' width='6%'>출고일</td>            	
            		<td class='title' width='6%'>영업구분</td>	
            		<td class='title' width='6%'>영업담당</td>            		
            		<td class='title' width='7%'>소속사</td>
					<td class='title' width='7%'>영업지점</td>
            		<td class='title' width='6%'>자체출고</td>	
					<td class='title' width='7%'>제조사</td>					
            		<td class='title' width='7%'>출고지점</td>
            		<td class='title' width='12%'>차명</td>
            		<td class='title' width='7%'>구입가격</td>
            		<td class='title' width='7%'>구입공급가</td>
				</tr>
			</table>
		</td>
	</tr>
<%
	if(stat_size > 0)
	{
%>
	<tr>
		<td id='td_con' class=line style='position:relative;' width='480'>
			<table border=0 cellspacing=1 cellpadding='0' width='100%'>
<%
		for(int i = 0 ; i < stat_size ; i++)
		{
			Hashtable stat = (Hashtable)stats.elementAt(i);
%>            	
           		<tr>
           			<td align='center' width='10%'><%=i+1%></td>
           			<td align='CENTER' width='25%'><%=stat.get("RENT_L_CD")%></td>
           			<td align='CENTER' width='19%'><%=stat.get("RENT_DT")%></td>
				<td align='left' width='29%'>&nbsp;<span title='<%=stat.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(stat.get("FIRM_NM")), 8)%></span></td>
            		        <td align='left' width='20%'>&nbsp;<span title='<%=stat.get("CAR_NM")%>'><%=Util.subData(String.valueOf(stat.get("CAR_NM")), 5)%></span></td>            		            		
            		</tr>
<%		}
%>
           		<tr>
           			<td class="title" colspan='5'>합계</td>             		            		
            		</tr>
			</table>
		</td>
		<td class=line width='1260'>
			<table border=0 cellspacing=1 cellpadding='0' width='100%'>
<%
		for(int i = 0 ; i < stat_size ; i++)
		{
			Hashtable stat = (Hashtable)stats.elementAt(i);
			
			total_amt1 	= total_amt1 + AddUtil.parseLong(String.valueOf(stat.get("CAR_F_AMT")));
			total_amt2 	= total_amt2 + AddUtil.parseLong(String.valueOf(stat.get("CAR_FS_AMT")));
				
%>            				
				<tr>	           		
                    <td align='center' width='6%'><%=stat.get("DLV_DT")%></td>
                    <td align='center' width='6%'><%=stat.get("PUR_BUS_ST")%></td>            		
                    <td align='center' width='6%'><span title='<%=stat.get("EMP_NM")%>'><%=Util.subData(String.valueOf(stat.get("EMP_NM")), 3)%></span></td>
		    <td align='center' width='7%'><%=stat.get("NM1")%></td>					
                    <td align='center' width='7%'><span title='<%=stat.get("BUS_OFF")%>'><%=Util.subData(String.valueOf(stat.get("BUS_OFF")), 6)%></span></td>					
                    <td align='center' width='6%'><%=stat.get("ONE_SELF")%></td>
		    <td align='center' width='7%'><%=stat.get("NM2")%></td>					
                    <td align='center' width='7%'><span title='<%=stat.get("DLV_OFF")%>'><%=Util.subData(String.valueOf(stat.get("DLV_OFF")), 6)%></span></td>
            	    <td width='12%'>&nbsp;<span title='<%=stat.get("CAR_NAME")%>'><%=Util.subData(String.valueOf(stat.get("CAR_NAME")), 14)%></span></td>
            	    <td align='right' width='7%'><%=Util.parseDecimal(String.valueOf(stat.get("CAR_F_AMT")))%></td>					
            	    <td align='right' width='7%'><%=Util.parseDecimal(String.valueOf(stat.get("CAR_FS_AMT")))%></td>					
           	  </tr>
<%
		}
%>
           		<tr>
           			<td class="title" colspan='9'>&nbsp;</td>           			
            		        <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt1)%></td>    		            		
            		        <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt2)%></td>   		            		            		        
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
		<td id='td_con' class=line style='position:relative;' width='480'>
			<table border=0 cellspacing=1 cellpadding='0' width='100%'>
				<tr>
					<td align='center'>등록된 데이타가 없습니다</td>
				</tr>
			</table>
		</td>
		<td width='1260' class='line'>
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