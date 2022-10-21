<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, card.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
   
   	int i_year = request.getParameter("s_year")==null?AddUtil.getDate2(1):Integer.parseInt(request.getParameter("s_year"));	
	int i_month = request.getParameter("s_month")==null?AddUtil.getDate2(2):Integer.parseInt(request.getParameter("s_month"));	
	
	String s_year = Integer.toString(i_year);
	String s_month = Integer.toString(i_month);
	
	String dt		= request.getParameter("dt")==null?"2":request.getParameter("dt");
	String ref_dt1 	= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 	= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	
	   String dept_nm = "";

%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
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
<table border="0" cellspacing="0" cellpadding="0" width="100%">
	<tr><td class=line2 colspan=2></td></tr>
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td class='line' width='33%' id='td_title' style='position:relative;'> 
<%
	int vt_size2 = 0;

	Vector vts2 = new Vector();
    vts2 = CardDb.getCardJungOilDtStatI(dt, ref_dt1, ref_dt2);

	vt_size2 = vts2.size();	

%>	 	
				<table border="0" cellspacing="1" cellpadding="0" width='100%' height="43">
          			<tr> 
						<td width='15%' class='title' style='height:45'>연번</td>
						<td width='28%' class='title'>부서</td>
						<td width='26%' class='title'>직급</td>
						<td width='31%' class='title'>성명</td>
					</tr>
				</table>
			</td>
	<td class='line' width='67%'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
         <tr>
            <td  rowspan="2"  class='title'>정산기준액</td>
            <td  colspan="2"  class='title'>업무용</td>
            <td  colspan="3"  class='title'>관리용</td>
            <td  rowspan="2" class='title' width='15%'>합계</td>
          
         </tr>
         <tr>
            <td width='14%' class='title'>지출</td>
            <td width='14%' class='title'>초과금액</td>
            <td width='14%' class='title'>예비차량</td>
            <td width='14%' class='title'>고객차량</td>
            <td width='14%' class='title'>소계</td>
                      
         </tr>
        </table>
	</td>
  </tr>	
<%	if(vt_size2 > 0){%>
  <tr>
	  <td class='line' width='33%' id='td_con' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <%	long t_amt1[] = new long[1];
      		long t_amt2[] = new long[1];
        	long t_amt3[] = new long[1];
        	long t_amt4[] = new long[1];
        	long t_amt5[] = new long[1];
        	long t_amt6[] = new long[1];
        	long t_amt7[] = new long[1];
        	
        	long b_amt[] = new long[1];
        
        %>
        <%	for(int i = 0 ; i < vt_size2 ; i++){
			Hashtable ht = (Hashtable)vts2.elementAt(i);
					
		//명칭
		dept_nm = ad_db.getUserDeptNm(String.valueOf(ht.get("BUY_USER_ID")));
					
		%>
          <tr> 
          	<td align="center" width='15%'><%= i+1%></td>
            <td width='28%' align="center"><%=dept_nm%></td>
            <td width='26%' align="center"><%=ht.get("USER_POS")%></td>
            <td width='31%' align="center"><%=ht.get("USER_NM")%>
            <a href="javascript:MM_openBrWindow('card_oil_sc_in.jsp?work_nm=<%=ht.get("USER_NM")%>&dt=<%=dt%>&ref_dt1=<%=ref_dt1%>&ref_dt2=<%=ref_dt2%>&auth_rw=1&user_id=<%= ht.get("BUY_USER_ID") %>&br_id=<%= ht.get("BR_ID") %>&j_amt=<%=ht.get("BUD_AMT")%>','popwin_vacation','scrollbars=yes,status=no,resizable=yes,width=860,height=560,top=50,left=50')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="리스트보기"></a></td>
          </tr>
          <%}%>
          <tr> 
            <td class=title colspan="5" align="center">합계</td>
          </tr>		  
        </table></td>
	<td class='line' width='67%'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <%for(int i = 0 ; i < vt_size2 ; i++){
					Hashtable ht = (Hashtable)vts2.elementAt(i);
					for(int j=0; j<1; j++){
				
					    t_amt1[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT_11")));
					    t_amt7[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT_14")));
						t_amt2[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT_12")));
						t_amt3[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT_13")));
						t_amt4[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT_11")))+ AddUtil.parseLong(String.valueOf(ht.get("AMT_12"))) + AddUtil.parseLong(String.valueOf(ht.get("AMT_13")));
						t_amt6[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT_12")))+ AddUtil.parseLong(String.valueOf(ht.get("AMT_13")));
				
						b_amt[j] += AddUtil.parseLong(String.valueOf(ht.get("BUD_AMT")));
					}
										
					%>
          <tr> 
 <%
        long tot = 0;
        tot = AddUtil.parseLong(String.valueOf(ht.get("AMT_11")))+ AddUtil.parseLong(String.valueOf(ht.get("AMT_12"))) + AddUtil.parseLong(String.valueOf(ht.get("AMT_13")));
        
        long remain = 0;
   //     remain = AddUtil.parseLong(String.valueOf(ht.get("AMT_14"))) ;
        remain = AddUtil.parseLong(String.valueOf(ht.get("BUD_AMT"))) - AddUtil.parseLong(String.valueOf(ht.get("AMT_11")));
        
   //     remain = AddUtil.parseLong(String.valueOf(ht.get("AMT_14"))) - 300000*bmon;
         if ( remain > 0 )     	remain = 0 ;
         if  (remain < 0 )  remain = remain * (-1);
         
             remain = 0;
               	 
       	 t_amt5[0] +=remain;
       	 
       	
         long stot = 0;
         stot = AddUtil.parseLong(String.valueOf(ht.get("AMT_12")))+ AddUtil.parseLong(String.valueOf(ht.get("AMT_13")));
        	
%>          
  			<td width='15%' align="right"><%=Util.parseDecimal(String.valueOf(ht.get("BUD_AMT")))%>원</td>
            <td width='14%' align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT_11")))%>원</td>
            <td width='14%' align="right"><%=Util.parseDecimal(remain)%>원</td>
            <td width='14%' align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT_12")))%>원</td>
            <td width='14%' align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT_13")))%>원</td>
            <td width='14%' align="right"><%=Util.parseDecimal(stot)%>원</td>
            <td width='15%' align="right"><%=Util.parseDecimal(tot)%>원</td>
            
          </tr>
          <%}%>
          <tr> 
            <td class=title style="text-align:right"><%=Util.parseDecimal(b_amt[0])%>원</td>
            <td class=title style="text-align:right"><%=Util.parseDecimal(t_amt1[0])%>원</td>
            <td class=title style="text-align:right"><%=Util.parseDecimal(t_amt5[0])%>원</td>
            <td class=title style="text-align:right"><%=Util.parseDecimal(t_amt2[0])%>원</td>
            <td class=title style="text-align:right"><%=Util.parseDecimal(t_amt3[0])%>원</td>
            <td class=title style="text-align:right"><%=Util.parseDecimal(t_amt6[0])%>원</td>
            <td class=title style="text-align:right"><%=Util.parseDecimal(t_amt4[0])%>원</td>
          </tr>	  
        </table>
	</td>
  </tr>
<%	}else{%>                     
  <tr>
	  <td class='line' width='33%' id='td_con' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
            <td align='center'>&nbsp;</td>
          </tr>
        </table></td>
	<td class='line' width='67%'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
		  <td>등록된 데이타가 없습니다</td>
		</tr>
	  </table>
	</td>
  </tr>
<% 	}%>
  </table>
</form>
</body>
</html>
