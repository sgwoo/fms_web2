<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, tax.*"%>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String site_id 		= request.getParameter("site_id")==null?"":request.getParameter("site_id");
	String r_req_dt 	= request.getParameter("r_req_dt")==null?"":request.getParameter("r_req_dt");
	String tax_out_dt 	= request.getParameter("tax_out_dt")==null?"":request.getParameter("tax_out_dt");
	String s_st 		= request.getParameter("s_st")==null?"":request.getParameter("s_st");
	
	Vector vts = IssueDb.getIssue1ListClient(client_id, site_id, r_req_dt, tax_out_dt, s_st);
	int vt_size = vts.size();
	
	long total_s_amt = 0;	
	long total_v_amt = 0;	
	long total_amt = 0;		
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
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
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:init()">
<form name='form1' action='' method='post' target='d_content'>
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='vt_size' value='<%=vt_size%>'>
<input type='hidden' name='client_id' value='<%=client_id%>'>
<input type='hidden' name='site_id' value='<%=site_id%>'>
<input type='hidden' name='r_req_dt' value='<%=r_req_dt%>'>
<input type='hidden' name='reg_st' value=''>
<input type='hidden' name='reg_gu' value=''>
<table border="0" cellspacing="0" cellpadding="0" width='100%'>
	<tr><td class=line2 colspan=2></td></tr>
  <tr id='tr_title' style='position:relative;z-index:1'>
	  <td class='line' width='50%' id='td_title' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
            <td width='10%' class='title'>연번</td>
            <td width='30%' class='title'>상호</td>			
            <td width='20%' class='title'>차량번호</td>			
            <td width='30%' class='title'>차명</td>			
            <td width='10%' class='title'>회차</td>
          </tr>
        </table></td>
	<td class='line' width='50%'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
            <td width='20%' class='title'>공급가</td>
            <td width='20%' class='title'>부가세</td>
            <td width='20%' class='title'>합계</td>			
            <td width='20%' class='title'>입금예정일</td>
            <td width='20%' class='title'>발행예정일</td>
          </tr>
        </table>
	</td>
  </tr>
<%	if(vt_size > 0){%>
  <tr>
	  <td class='line' width='50%' id='td_con' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <%for(int i = 0 ; i < vt_size ; i++){
							Hashtable ht = (Hashtable)vts.elementAt(i);
							String client_cont = "-";
							if(!String.valueOf(ht.get("CNT1")).equals("")) client_cont += "<font color=red>장</font>-";
							if(!String.valueOf(ht.get("CNT2")).equals("")) client_cont += "<font color=red>셀</font>-";
							if(!String.valueOf(ht.get("CNT3")).equals("")) client_cont += "<font color=red>기</font>-";
					%>
          <tr> 
            <td width='10%' align='center'><a name="<%=i+1%>"><%=i+1%></a></td>
            <td width='30%' align='center'><span title='<%=ht.get("FIRM_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("FIRM_NM")), 8)%><a href="javascript:parent.view_cont('<%=ht.get("CLIENT_ID")%>','<%=i+1%>')" onMouseOver="window.status=''; return true"></a></span></td>			
            <td width='20%' align='center'><%=ht.get("CAR_NO")%></td>
            <td width='30%' align='center'><span title='<%=ht.get("CAR_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("CAR_NM")), 8)%></span></td>
            <td width='10%' align='center'><%=ht.get("FEE_TM")%>회</td>
          </tr>
          <%	total_s_amt = total_s_amt + AddUtil.parseLong(String.valueOf(ht.get("FEE_S_AMT")));
							total_v_amt = total_v_amt + AddUtil.parseLong(String.valueOf(ht.get("FEE_V_AMT")));
							total_amt   = total_amt + AddUtil.parseLong(String.valueOf(ht.get("FEE_AMT")));
		  			}
		  		%>
          <tr> 
            <td class="star" align='center'>&nbsp;</td>
            <td class="star" align='center'>합계</td>			
            <td class="star" align='center'>&nbsp;</td>
            <td class="star" align='center'>&nbsp;</td>
            <td class="star" align='center'>&nbsp;</td>
          </tr>		  
        </table>
    </td>
	  <td class='line' width='50%'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <%for(int i = 0 ; i < vt_size ; i++){
							Hashtable ht = (Hashtable)vts.elementAt(i);%>
          <tr> 
            <td width='20%' align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("FEE_S_AMT")))%>원&nbsp;</td>
            <td width='20%' align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("FEE_V_AMT")))%>원&nbsp;</td>
            <td width='20%' align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("FEE_AMT")))%>원&nbsp;</td>
            <td width='20%' align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("R_FEE_EST_DT")))%></td>
            <td width='20%' align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("R_REQ_DT")))%></td>						
          </tr>
          <%}%>
          <tr> 
            <td class="star" align='right'><%=AddUtil.parseDecimal(total_s_amt)%>원&nbsp;</td>
            <td class="star" align='right'><%=AddUtil.parseDecimal(total_v_amt)%>원&nbsp;</td>			
            <td class="star" align='right'><%=AddUtil.parseDecimal(total_amt)%>원&nbsp;</td>
            <td class="star" align='center'>&nbsp;</td>
            <td class="star" align='center'>&nbsp;</td>
          </tr>		  		  
        </table>
	</td>
  </tr>
<%	}else{%>                     
  <tr>
	  <td class='line' width='50%' id='td_con' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
            <td align='center'>등록된 데이타가 없습니다</td>
          </tr>
        </table>
    </td>
	  <td class='line' width='50%'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
		        <td>&nbsp;</td>
		      </tr>
	    </table>
	  </td>
  </tr>
<% 	}%>
</table>
</form>
</body>
</html>
