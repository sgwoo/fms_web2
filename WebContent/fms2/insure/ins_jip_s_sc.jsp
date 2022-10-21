<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.insur.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
   	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
  
   	String s_dt = request.getParameter("s_dt")==null?"20150210":request.getParameter("s_dt");
   	String s_use = request.getParameter("s_use")==null?"2":request.getParameter("s_use");
		
	
	InsDatabase ai_db = InsDatabase.getInstance();
	
	Vector vt = ai_db.getJipInsureCarUseList(s_dt, s_use);
	int vt_size = vt.size();
	
	long t_amt1[] = new long[1];
    long t_amt2[] = new long[1];
    long t_amt3[] = new long[1];
						 		
%>
<html>
<head>
<title>FMS</title>
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
	
	
	


//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body onLoad="javascript:init()">

<table border="0" cellspacing="0" cellpadding="0" width='1000'>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td class='line' width='1000' id='td_title' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
			    <tr>
					<td width='40' class='title'>연번</td>
					<td width='50' class='title'>구분</td>
					<td width='150' class='title'>차량번호</td>
					<td width='200' class='title'>차대번호</td>	
					<td width='250' class='title'>대표차종명</td>
					<td width='80' class='title'>갱신대수</td>
					<td width='120' class='title'>현재보험료</td>
					<td width='140' class='title'>보험료합계</td>				
				</tr>
			</table>
		</td>
	</tr>
<%
	if(vt_size > 0)
	{
%>
	<tr>
		<td class='line' width='1000' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%
		for(int i = 0 ; i < vt_size ; i++)
		{
			Hashtable ht = (Hashtable)vt.elementAt(i);
			
			for(int j=0; j<1; j++){
				
						t_amt1[j] += AddUtil.parseLong(String.valueOf(ht.get("CAR_CNT")));
						t_amt2[j] += AddUtil.parseLong(String.valueOf(ht.get("INS_AMT")));
						t_amt3[j] += AddUtil.parseLong(String.valueOf(ht.get("INS_T_AMT")));
			
			}
%>
				<tr>
					<td  width='40' align='center'><%=i+1%></td>
					<td  width='50' align='center'><%=ht.get("S_ST")%></td>					
					<td  width='150' align='center'><%=ht.get("CAR_NO")%></td>							
					<td  width='200' align='center'><%=ht.get("CAR_NUM")%></td>
					<td  width='250' align='center'><%=ht.get("REMARKS")%></td>
					<td  width='80' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("CAR_CNT")))%></td>			
					<td  width='120' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("INS_AMT")))%></td>					
					<td  width='140' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("INS_T_AMT")))%></td>					
					
				</tr>
<%
		}
%>		
				 <tr> 
			            <td class=title align="center" colspan=5> &nbsp;</td>
			            <td class=title style="text-align:right"><%=Util.parseDecimal(t_amt1[0])%></td>
			            <td class=title style="text-align:right"></td>
			            <td class=title style="text-align:right"><%=Util.parseDecimal(t_amt3[0])%></td>
			      
			           </tr>	  
           
			</table>
		</td>
<%	}
	else
	{
%>                     
	<tr>
		<td class='line' width='1000' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td align='center'>					
					등록된 데이타가 없습니다</td>
				</tr>
			</table>
		</td>
			</tr>
<%                     
	}                  
%>

</table>
<table>
   <tr>
      <td><font color=red>***</font>&nbsp;가입조건은 연령 26세이상. 대물 1억, 자기신체 사망 1억 </td>
  </tr>
</table>

</body>
</html>
