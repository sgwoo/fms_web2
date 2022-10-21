<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.insur.*"%>
<jsp:useBean id="ai_db" class="acar.insur.InsDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function view_car_exp(car_mng_id){
		window.open('view_exp_car_list.jsp?car_mng_id='+car_mng_id, "VIEW_EXP_LIST", "left=0, top=0, width=850, height=768, scrollbars=yes, status=yes, resize");
	}

//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
<%
	String car_ext 	= request.getParameter("car_ext")==null?"":request.getParameter("car_ext");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String car_use 	= request.getParameter("car_use")==null?"":request.getParameter("car_use");
	int total_su = 0;
	long total_amt = 0;
	long total_amt2 = 0;
	
	
	//미등록 자동차세
	Vector vt = ai_db.getExpScdNonRegStat(car_ext, gubun1, "list", car_use);
	int vt_size = vt.size();
%>
<form name='form1' method='post'>
<table border="0" cellspacing="0" cellpadding="0" width=1010>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>자동차세 미등록 리스트</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr> 
	<tr>
	    <td class=line>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		        <tr valign="middle" align="center"> 
        		    <td width='30' rowspan="2" class=title>연번</td>
        		    <td width='80' rowspan="2" class=title>차량번호</td>
        		    <td width='100' rowspan="2" class=title >차명</td>
        		    <td width='70' rowspan="2" class=title>최초등록일</td>
        		    <td colspan="4" class=title>계산변수</td>
        		    <td colspan="3" class=title>계산결과</td>
        		    <td colspan="3" class=title>기납부</td>			
	            </tr>
		        <tr valign="middle" align="center">
        		    <td width='60' class=title>지역</td>		  
        		    <td width='60' class=title>용도</td>		  
        		    <td width='60' class=title>차종</td>		  			
        		    <td width="60" class=title>배기량</td>
        		    <td width="70" class=title>자동차세</td>
        		    <td width='70' class=title>지방교육세</td>		  
        		    <td width='100' class=title>합계세액</td>
        		    <td width='70' class=title>금액</td>
        		    <td width='100' class=title>일자</td>
        		    <td width='80' class=title>환급사유일</td>			
		        </tr>
<%		for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);%>
		        <tr> 
        		    <td <%if(String.valueOf(ht.get("SUI_ST")).equals("매각")){%>class=g<%}%> align='center'><%=i+1%></td>
        		    <td <%if(String.valueOf(ht.get("SUI_ST")).equals("매각")){%>class=g<%}%> align='center'><a href="javascript:view_car_exp('<%=ht.get("CAR_MNG_ID")%>')"><%=ht.get("CAR_NO")%></a></td>
        		    <td <%if(String.valueOf(ht.get("SUI_ST")).equals("매각")){%>class=g<%}%> align='center'><%=ht.get("CAR_NM")%></td>
        		    <td <%if(String.valueOf(ht.get("SUI_ST")).equals("매각")){%>class=g<%}%> align='center'><%=ht.get("INIT_REG_DT")%></td>			
        		    <td <%if(String.valueOf(ht.get("SUI_ST")).equals("매각")){%>class=g<%}%> align='center'><%=ht.get("CAR_EXT")%></td>
        		    <td <%if(String.valueOf(ht.get("SUI_ST")).equals("매각")){%>class=g<%}%> align='center'><%=ht.get("CAR_USE")%></td>			
        		    <td <%if(String.valueOf(ht.get("SUI_ST")).equals("매각")){%>class=g<%}%> align='center'><%=ht.get("CAR_ST")%></td>
        		    <td <%if(String.valueOf(ht.get("SUI_ST")).equals("매각")){%>class=g<%}%> align='right'><%=Util.parseDecimal(String.valueOf(ht.get("DPM")))%>cc&nbsp;</td>
        		    <td <%if(String.valueOf(ht.get("SUI_ST")).equals("매각")){%>class=g<%}%> align='right'><%=Util.parseDecimal(String.valueOf(ht.get("CAR_TAX")))%>원&nbsp;</td>			
        		    <td <%if(String.valueOf(ht.get("SUI_ST")).equals("매각")){%>class=g<%}%> align='right'><%=Util.parseDecimal(String.valueOf(ht.get("EDU_TAX")))%>원&nbsp;</td>
        		    <td <%if(String.valueOf(ht.get("SUI_ST")).equals("매각")){%>class=g<%}%> align='right'><%=Util.parseDecimal(String.valueOf(ht.get("TOT_TAX")))%>원&nbsp;</td>
        		    <td <%if(String.valueOf(ht.get("SUI_ST")).equals("매각")){%>class=g<%}%> align='right'><%=Util.parseDecimal(String.valueOf(ht.get("EXP_AMT")))%>원&nbsp;</td>			
        		    <td <%if(String.valueOf(ht.get("SUI_ST")).equals("매각")){%>class=g<%}%> align='center'><%=ht.get("EXP_DT")%></td>
        		    <td <%if(String.valueOf(ht.get("SUI_ST")).equals("매각")){%>class=g<%}%> align='center'><%=ht.get("RTN_CAU_DT")%></td>			
		        </tr>
  <%		if(!String.valueOf(ht.get("TOT_TAX")).equals("")){
	  			total_amt = total_amt + Long.parseLong(String.valueOf(ht.get("TOT_TAX")));
			  	total_amt2 = total_amt2 + Long.parseLong(String.valueOf(ht.get("EXP_AMT")));
			}
		  }%>
				<tr>
					<td class="title">&nbsp;</td>
					<td class="title">&nbsp;</td>					
					<td class="title">&nbsp;</td>
					<td class="title">&nbsp;</td>
					<td class="title">&nbsp;</td>					
					<td class="title">&nbsp;</td>										
					<td class="title">&nbsp;</td>	
					<td class="title">&nbsp;</td>
					<td class="title">&nbsp;</td>					
					<td class="title">&nbsp;</td>															
					<td class="title" style='text-align:right'>ⓐ<%=Util.parseDecimal(total_amt)%>원&nbsp;</td>
					<td class="title" style='text-align:right'>ⓑ<%=Util.parseDecimal(total_amt2)%>원&nbsp;</td>
					<td class="title" style='text-align:right'>ⓒ<%=Util.parseDecimal(total_amt-total_amt2)%>원&nbsp;</td>
					<td class="title" align='center'>ⓒ=ⓐ-ⓑ</td>					
				</tr>		  
	        </table>
	    </td>
	</tr>
	<tr>
		<td align='right'>
		  <a href='javascript:window.close();'><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
		</td>	
	</tr>	
</table>
</form>  
</body>
</html>
