<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, tax.*, acar.user_mng.*"%>
<jsp:useBean id="ScdMngDb" scope="page" class="tax.ScdMngDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//  사업자번호,주민번호는 '-' 뺀다
	if(s_kd.equals("4")) t_wd = AddUtil.replace(t_wd, "-", "");
	
	st_dt = AddUtil.replace(st_dt, "-", "");
	end_dt = AddUtil.replace(end_dt, "-", "");
		
	Vector vts = ScdMngDb.getTaxMngList_201401(s_br, chk1, chk2, chk3, chk4, chk5, chk6, chk7, gubun1, gubun2, gubun3, gubun4, st_dt, end_dt, s_kd, t_wd1, t_wd2, sort, asc);
	int vt_size = vts.size();
	
	long total_t_amt 	= 0;
	long total_s_amt 	= 0;
	long total_v_amt 	= 0;
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
<table border="0" cellspacing="0" cellpadding="0" width=1530>
    <tr>
        <td class=line2 colspan="2"></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>
	<td class='line' width='430' id='td_title' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='40' class='title'>연번</td>
                    <td width='90' class='title'>일련번호</td>
                    <td width='120' class='title'>상호</td>
                    <td width='100' class='title'>사업자번호</td>
                    <td width='80' class='title'>세금일자</td>		  
                </tr>
            </table>
        </td>
	<td class='line' width='1100'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='70' class='title'>등록구분</td>		  
                    <td width='110' class='title'>수정구분</td>		  			
                    <td width='110' class='title'>차량번호</td>		  
                    <td width='130' class='title'>항목</td>
                    <td width='90' class='title'>공급가</td>
                    <td width='80' class='title'>부가세</td>
                    <td width='90' class='title'>합계</td>
                    <td width='80' class='title'>작성일자</td>
                    <td width='200' class='title'>자동전표</td>
                    <td width='140' class='title'>전자세금계산서</td>
                </tr>
	    </table>
	</td>
    </tr>
    <%if(vt_size > 0){%>
    <tr>
	<td class='line' width='430' id='td_con' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <%for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vts.elementAt(i);%>
                <tr> 
                    <td <%if(String.valueOf(ht.get("TAX_ST")).equals("M"))out.println("class='is'");%> width='40' align='center'><a name="<%=i+1%>"><%=i+1%></a></td>
                    <td <%if(String.valueOf(ht.get("TAX_ST")).equals("M"))out.println("class='is'");%> width='90' align='center'><a href="javascript:parent.view_tax('<%=ht.get("TAX_NO")%>','<%=i+1%>')" onMouseOver="window.status=''; return true" title='세금계산서 세부내역 보기'><%=ht.get("TAX_NO")%></a></td>
                    <td <%if(String.valueOf(ht.get("TAX_ST")).equals("M"))out.println("class='is'");%> width='120'>			
				<%if(s_kd.equals("12") && (nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("본사출납",user_id))){%>
				&nbsp;<a href="javascript:parent.cl_enp_h('<%=ht.get("RENT_L_CD")%>','<%=ht.get("CLIENT_ID")%>','<%=ht.get("FIRM_NM")%>')" onMouseOver="window.status=''; return true" title='사업자등록증이력보기'><span title='<%=ht.get("FIRM_NM")%>, 사업자등록증이력보기 링크'><%=AddUtil.subData(String.valueOf(ht.get("FIRM_NM")), 6)%></span></a>			
				<%}else{%>
				&nbsp;<span title='<%=ht.get("FIRM_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("FIRM_NM")), 6)%></span>
				<%}%>
                    </td>			
                    <td <%if(String.valueOf(ht.get("TAX_ST")).equals("M"))out.println("class='is'");%> width='100' align='center'>
			      <%if(String.valueOf(ht.get("ENP_NO")).equals("") || String.valueOf(ht.get("ENP_NO")).equals("0000000000")){%>
			      <%=AddUtil.ChangeEnpH(String.valueOf(ht.get("SSN")))%>
			      <%}else{%>
			      <%=AddUtil.ChangeEnpH(String.valueOf(ht.get("ENP_NO")))%>
			      <%}%>			
                    </td>
                    <td <%if(String.valueOf(ht.get("TAX_ST")).equals("M"))out.println("class='is'");%> width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("TAX_DT")))%></td>				  
                </tr>
                <%}%>
		<%if(vt_size < 100){%>
                <tr> 
		    <td colspan='5'>&nbsp;</td>
                </tr>		  		  	
		<%}%>		  
            </table>
	</td>
	<td class='line' width='1100'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <%for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vts.elementAt(i);
					  
					  if(vt_size < 100){
					  		total_t_amt 	= total_t_amt + Long.parseLong(String.valueOf(ht.get("TAX_AMT")));
							total_s_amt 	= total_s_amt + Long.parseLong(String.valueOf(ht.get("TAX_SUPPLY")));
							total_v_amt 	= total_v_amt + Long.parseLong(String.valueOf(ht.get("TAX_VALUE")));
					  }
					  %>
                <tr> 
                    <td <%if(String.valueOf(ht.get("TAX_ST")).equals("M"))out.println("class='is'");%> width='70' align="center">
			      <%if(!String.valueOf(ht.get("TAX_ST")).equals("O")){%>
			      <font color=red><%=ht.get("TAX_ST_NM")%></font>
			      <%}else{%>
		              <%=ht.get("TAX_ST_NM")%>
			      <%}%>			            
                    </td>														  
                    <td <%if(String.valueOf(ht.get("TAX_ST")).equals("M"))out.println("class='is'");%> width='110' align="center">
			      <%=ht.get("DOCTYPE_NM")%>			            
                    </td>					
                    <td <%if(String.valueOf(ht.get("TAX_ST")).equals("M"))out.println("class='is'");%> width='110' align="center">
			  <%if(String.valueOf(ht.get("UNITY_CHK")).equals("1")){%>
			  <font color='red'><b>[통합]</b></font>
			  <%}%>
			  <%=ht.get("CAR_NO")%>
		    </td>
                    <td <%if(String.valueOf(ht.get("TAX_ST")).equals("M"))out.println("class='is'");%> width='130' align="center">
			  <%int tax_g_size = 6;%>
			  <%if(String.valueOf(ht.get("GUBUN")).equals("")){
					tax_g_size = tax_g_size-1;%>
			  <font color='red'><b>[직접]</b></font>
			  <%}%>
			  <%if(AddUtil.parseInt(String.valueOf(ht.get("REG_DT"))) >= 20100929 && String.valueOf(ht.get("GUBUN")).equals("1") && !String.valueOf(ht.get("FEE_TM")).equals("") && !String.valueOf(ht.get("TM_PRINT_YN")).equals("N")){%>
			  <%=ht.get("FEE_TM")%>회차
			  <%}%>			  
			  <span title='<%=ht.get("TAX_G")%>'><%=AddUtil.subData(String.valueOf(ht.get("TAX_G")), tax_g_size)%></span>
		    </td>
                    <td <%if(String.valueOf(ht.get("TAX_ST")).equals("M"))out.println("class='is'");%> width='90' align="right"><%=Util.parseDecimal(String.valueOf(ht.get("TAX_SUPPLY")))%></td>
                    <td <%if(String.valueOf(ht.get("TAX_ST")).equals("M"))out.println("class='is'");%> width='80' align="right"><%=Util.parseDecimal(String.valueOf(ht.get("TAX_VALUE")))%></td>
                    <td <%if(String.valueOf(ht.get("TAX_ST")).equals("M"))out.println("class='is'");%> width='90' align="right"><%=Util.parseDecimal(String.valueOf(ht.get("TAX_AMT")))%></td>
                    <td <%if(String.valueOf(ht.get("TAX_ST")).equals("M"))out.println("class='is'");%> width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%></td>
                    <td <%if(String.valueOf(ht.get("TAX_ST")).equals("M"))out.println("class='is'");%> width='200' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("AUTODOCU_WRITE_DATE")))%>(<%=ht.get("AUTODOCU_DATA_NO")%>)</td>
                    <td <%if(String.valueOf(ht.get("TAX_ST")).equals("M"))out.println("class='is'");%> width='140' align="center">
			<%	if(String.valueOf(ht.get("PUBCODE")).equals("")){%>
			  <a href="javascript:parent.SaleEBill('1','<%=ht.get("TAX_NO")%>')"><img src=/acar/images/center/button_detail.gif align=absmiddle border=0></a>
			<%	}else{%>
			  <a href="javascript:parent.viewTaxInvoice('<%=ht.get("PUBCODE")%>')" title='공급자용'><%=ht.get("STATUS")%></a>
			  &nbsp;<a href="javascript:parent.viewTaxInvoice2('<%=ht.get("PUBCODE")%>')" title='공급받는자용'><img src=/acar/images/center/button_detail.gif align=absmiddle border=0></a>
			<%	}%>		
                    </td>		
                </tr>
                <%}%>
		<%if(vt_size < 100){%>
                <tr> 
                    <td colspan='4' align='center'>합계</td>
			<td class="title" style='text-align:right'><%=Util.parseDecimal(total_s_amt)%></td>
			<td class="title" style='text-align:right'><%=Util.parseDecimal(total_v_amt)%></td>
			<td class="title" style='text-align:right'><%=Util.parseDecimal(total_t_amt)%></td>
                    <td colspan='3'>&nbsp;</td>
                </tr>		  		  			  	
		<%}%>
            </table>
	</td>
    </tr>
    <%}else{%>                     
    <tr>
	    <td class='line'  colspan=2> 
	      <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
            <td align='center'>등록된 데이타가 없습니다</td>
          </tr>
        </table>
      </td>
    </tr>
    <%}%>
  </table>
</form>
<script language="JavaScript">
<!--
//-->
</script>
</body>
</html>
