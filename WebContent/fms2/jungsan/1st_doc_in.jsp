<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="JsDb" scope="page" class="card.JungSanDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");	
	String dept_id = request.getParameter("dept_id")==null?"":request.getParameter("dept_id");	
	String user_nm	= request.getParameter("user_nm")==null?"":request.getParameter("user_nm");	
	String dt		= request.getParameter("dt")==null?"2":request.getParameter("dt");
	String ref_dt1 	= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 	= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");	
	String st_year		= request.getParameter("st_year")==null?"":request.getParameter("st_year");	
	String s_gubun3 =  request.getParameter("s_gubun3")==null?"":request.getParameter("s_gubun3");
	int year =AddUtil.getDate2(1);
			
	long gt_amt[] = new long[10];  //grand total
	long st1_amt[] = new long[10];  //sub total
	long st2_amt[] = new long[10];  //sub total
	long amt[] = new long[10];  //
		
	int vt_size2 = 0;
	Vector vts2 = new Vector();
	vts2 = JsDb.getCardJungDtStatNew_1st(dt, st_year, ref_dt1, ref_dt2, br_id, dept_id, user_id, s_gubun3);
	vt_size2 = vts2.size();
		
	long a_tot = 0; //잔액
	long sa_tot = 0; //잔액
	long ta_tot = 0; //잔액
	
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">

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
	
			
//팝업윈도우 열기
function MM_openBrWindow(theURL,winName,features) { //v2.0
	window.open(theURL,winName,features);
}
//-->	
</script>
</head>

<body onLoad="javascript:init()">
<form action="" name="form1" method="POST">
	<input type='hidden' name='user_id' value='<%=user_id%>'>
<table border="0" cellspacing="0" cellpadding="0" width="100%">
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%' >
				<tr>
					<td rowspan="3" class='title' width='10%'>귀속월</td>
				    <td colspan="5" class='title' width='45%'>설정금액</td>
				    <td colspan="4" class='title' width='36%'>지출금액</td>
				    <td rowspan="3" class='title' width='9%'>정산</td>
				</tr>
				<tr>
					<td class='title' rowspan="2" width='9%'>중식대</td>
				    <td class='title' colspan="2" >복리후생</td>
				    <td class='title' rowspan="2" width='9%'>팀장활동비</td>
				    <td class='title' rowspan="2" width='9%'>소계(A)</td>
				    <td class='title' rowspan="2" width='9%'>식대</td>
				    <td class='title' rowspan="2" width='9%'>복리후생</td>
				    <td class='title' rowspan="2" width='9%'>팀장활동비</td>
				    <td class='title' rowspan="2" width='9%'>소계(B)</td>
			    </tr>
			    <tr>
					<td class='title' width='9%'>회식비</td>
				    <td class='title' width='9%'>특별(근속,방역)</td>				
			    </tr>
			</table>
		</td>
	</tr>

	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%' >
<% 	
		String chk= "";
		String n_chk= "";
	
	  	for(int i = 0 ; i < vt_size2 ; i++){
				Hashtable ht = (Hashtable)vts2.elementAt(i);
			
				for (int j = 1 ; j <= 8 ; j++){
					
					amt[j] = AddUtil.parseLong(String.valueOf(ht.get("AMT"+(j))));   //  total
					
					gt_amt[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT"+(j))));  //grand total
					
					if(AddUtil.parseLong(String.valueOf(ht.get("MM"))) < 7 ){
						st1_amt[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT"+(j))));   // sub total
						n_chk  = "1"; 		
					} else {
						st2_amt[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT"+(j))));   // sub total
						n_chk  = "2"; 
					}					
				}
				
					
				if ( i == 0 ) {
					chk = "1";
					n_chk = "1";
				}
								
			    a_tot = 0; //잔액			 
				if(ht.get("USER_ID").equals("000003")||ht.get("USER_ID").equals("000004")||ht.get("USER_ID").equals("000005")||ht.get("USER_ID").equals("000026")  ||ht.get("USER_ID").equals("000028")   ||ht.get("USER_ID").equals("000237") ){
				//	a_tot = (AddUtil.parseLong(String.valueOf(ht.get("G4_AMT"))) +AddUtil.parseLong(String.valueOf(ht.get("S_G4_AMT"))) ) - ( AddUtil.parseLong(String.valueOf(ht.get("G2_AMT"))) );
					a_tot = amt[4]+amt[5]-amt[2]; 
				
				}else{
					a_tot = amt[8]+amt[4]+amt[5]+amt[6] -amt[1] -amt[2]-amt[3]; 
				}
			    
%>
<%
		 if(!chk.equals(n_chk) ) { 
	          chk = "2";	       
%>
				<tr>
					<td class='title' width='10%'>1분기 소계</td>
					<td class='title' width='9%'><div align="right"><%=Util.parseDecimal(st1_amt[8])%></div></td>
					<td class='title' width='9%'><div align="right"><%=Util.parseDecimal(st1_amt[4])%></div></td>
		            <td class='title' width='9%'><div align="right"><%=Util.parseDecimal(st1_amt[5])%></div></td> 
		            <td class='title' width='9%'><div align="right"><%=Util.parseDecimal(st1_amt[6])%></div></td> 
					<td class='title' width='9%'><div align="right"><%=Util.parseDecimal(st1_amt[8]+st1_amt[4]+st1_amt[5]+st1_amt[6])%></div></td>
					<td class='title' width='9%'><div align="right"><%=Util.parseDecimal(st1_amt[1])%></div></td>
					<td class='title' width='9%'><div align="right"><%=Util.parseDecimal(st1_amt[2])%></div></td>
					<td class='title' width='9%'><div align="right"><%=Util.parseDecimal(st1_amt[3])%></div></td>
					<td class='title' width='9%'><div align="right"><%=Util.parseDecimal(st1_amt[1]+st1_amt[2]+st1_amt[3])%></div></td>					
					<td class='title' width='9%'><div align="right"><%=Util.parseDecimal(sa_tot)%></div></td>
				</tr>
				
<%      sa_tot = 0;  
		} 
        
		sa_tot += a_tot; 	
		ta_tot += a_tot;		
%>
    					
				<tr>
					<td class='title' width='10%'>
					<%if ( String.valueOf(ht.get("MM")).equals("00") ) {%> 이월			<%} else {%>					<%=Util.parseDecimal(String.valueOf(ht.get("MM")))%>월					<% } %></td>
					<td width='9%' align="right"><%=Util.parseDecimal(amt[8])%></td>
					<td width='9%' align="right"><%=Util.parseDecimal(amt[4])%></td>
					<td width='9%' align="right"><%=Util.parseDecimal(amt[5])%></td>
					<td width='9%' align="right"><%=Util.parseDecimal(amt[6])%></td>
					<td width='9%' align="right"><%=Util.parseDecimal(amt[8]+amt[4]+amt[5]+amt[6])%></td>
					<td width='9%' align="right"><%=Util.parseDecimal(amt[1])%></td>
					<td width='9%' align="right"><%=Util.parseDecimal(amt[2])%></td>
					<td width='9%' align="right"><%=Util.parseDecimal(amt[3])%></td>
					<td width='9%' align="right"><%=Util.parseDecimal(amt[1]+amt[2]+amt[3])%></td>				
					<td width='9%' align="right"><%=Util.parseDecimal(a_tot)%></td>
								
<%	}	%>				
				
				<tr>
					<td class='title' >2분기 소계</td>
					<td class='title' ><div align="right"><%=Util.parseDecimal(st2_amt[8])%></div></td>
					<td class='title' ><div align="right"><%=Util.parseDecimal(st2_amt[4])%></div></td>
		            <td class='title' ><div align="right"><%=Util.parseDecimal(st2_amt[5])%></div></td> 
		            <td class='title' ><div align="right"><%=Util.parseDecimal(st2_amt[6])%></div></td> 
					<td class='title' ><div align="right"><%=Util.parseDecimal(st2_amt[8]+st2_amt[4]+st2_amt[5]+st2_amt[6])%></div></td>
					<td class='title' ><div align="right"><%=Util.parseDecimal(st2_amt[1])%></div></td>
					<td class='title' ><div align="right"><%=Util.parseDecimal(st2_amt[2])%></div></td>
					<td class='title' ><div align="right"><%=Util.parseDecimal(st2_amt[3])%></div></td>
					<td class='title' ><div align="right"><%=Util.parseDecimal(st2_amt[1]+st2_amt[2]+st2_amt[3])%></div></td>					
					<td class='title' ><div align="right"><%=Util.parseDecimal(sa_tot)%></div></td>
				</tr>	
				<tr>
					<td class='title' >합계</td>
					<td class='title' ><div align="right"><%=Util.parseDecimal(gt_amt[8])%></div></td>
					<td class='title' ><div align="right"><%=Util.parseDecimal(gt_amt[4])%></div></td>
		            <td class='title' ><div align="right"><%=Util.parseDecimal(gt_amt[5])%></div></td> 
		            <td class='title' ><div align="right"><%=Util.parseDecimal(gt_amt[6])%></div></td> 
					<td class='title' ><div align="right"><%=Util.parseDecimal(gt_amt[8]+gt_amt[4]+gt_amt[5]+gt_amt[6])%></div></td>
					<td class='title' ><div align="right"><%=Util.parseDecimal(gt_amt[1])%></div></td>
					<td class='title' ><div align="right"><%=Util.parseDecimal(gt_amt[2])%></div></td>
					<td class='title' ><div align="right"><%=Util.parseDecimal(gt_amt[3])%></div></td>
					<td class='title' ><div align="right"><%=Util.parseDecimal(gt_amt[1]+gt_amt[2]+gt_amt[3])%></div></td>					
					<td class='title' ><div align="right"><%=Util.parseDecimal(ta_tot)%></div></td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</form>
</body>
</html>