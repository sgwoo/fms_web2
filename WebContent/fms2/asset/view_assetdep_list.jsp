<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.asset.*"%>

<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
<%
	String asset_ym = request.getParameter("asset_ym")==null?"":request.getParameter("asset_ym");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");


	long t1 = 0;
	long t2 = 0;
	long t3 = 0;
	long t4 = 0;
	
	AssetDatabase as_db = AssetDatabase.getInstance();
	
	
	Vector vts = as_db.getAssetDepYmList(asset_ym, gubun1);
	int asset_size = vts.size();

%>
<form name='form1' method='post'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>감각상각 내역 리스트 ( <%=asset_ym%> )</span></td>
    </tr>  
    <tr><td class=line2></td></tr>
  	<tr>
	    <td class=line>
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
    		    <tr valign="middle" align="center"> 
        		    <td width='4%' class=title>연번</td>
        		    <td width='8%' class=title>자산코드</td>
        		    <td width='15%' class=title>자산명</td>
        		    <td width='9%' class=title >자동차번호</td>
        		    <td width='8%' class=title >취득일자</td>
        		    <td width='8%' class=title >내용연수</td>
        		    <td width='6%' class=title >상각율</td>
        		    <td width='11%' class=title >당기상각액</td>
        		    <td width='11%' class=title>전월상각누계</td>
        		    <td width='11%' class=title>당월상각액</td>
        		    <td width='9%' class=title>구매보조금</td>
    		    
    	        </tr>
    		
    <%		for(int i = 0 ; i < asset_size ; i++){
    				Hashtable ht = (Hashtable)vts.elementAt(i);%>
    		    <tr> 
        		    <td align='center'><%=i+1%></td>
        		    <td align='center'><%=ht.get("ASSET_CODE")%></td>
        		    <td align='left'>&nbsp;<%=Util.subData(String.valueOf(ht.get("ASSET_NAME")), 8)%></td>
        		    <td align='center'><%=ht.get("CAR_NO")%></td>			
        		    <td align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("GET_DATE")))%></td>
        		    <td align='center'><%=ht.get("LIFE_EXIST")%></td>
        		    <td align='right'><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht.get("NDEPRE_RATE"))), 3) %>&nbsp;</td>
        		    <td align='right'><%=Util.parseDecimal(String.valueOf(ht.get("DEP_EDIT")))%>&nbsp;</td>
        		    <td align='right'><%=Util.parseDecimal(String.valueOf(ht.get("AC_DEP_MAMT")))%>&nbsp;</td>
        		    <td align='right'><%=Util.parseDecimal(String.valueOf(ht.get("DEP_MAMT")))%></td>
        		    <td align='right'><%=Util.parseDecimal(String.valueOf(ht.get("GDEP_MAMT")))  %></td>
    		    </tr>
    <%		
      			t1 = t1 + Long.parseLong(String.valueOf(ht.get("DEP_EDIT")));
      			t2 = t2 + Long.parseLong(String.valueOf(ht.get("AC_DEP_MAMT")));
      			t3 = t3 + Long.parseLong(String.valueOf(ht.get("DEP_MAMT")));
      	    	t4 = t4 + Long.parseLong(String.valueOf(ht.get("GDEP_MAMT")));
      			
    		
     }%>
    		    <tr>
    			    <td class="title">&nbsp;</td>
    			    <td class="title">&nbsp;</td>					
    			    <td class="title">&nbsp;</td>					
    			    <td class="title">&nbsp;</td>
    			    <td class="title">&nbsp;</td>
    			    <td class="title">&nbsp;</td>					
    			    <td class="title">&nbsp;</td>	
    			    <td class="title" style="text-align:right"><%=Util.parseDecimal(t1)%>&nbsp;</td>	
    			    <td class="title" style="text-align:right"><%=Util.parseDecimal(t2)%>&nbsp;</td>					
    			    <td class="title" style="text-align:right" ><%=Util.parseDecimal(t3)%></td>
    			    <td class="title" style="text-align:right" ><%=Util.parseDecimal(t4)%></td>
    		    </tr>		  
    	    </table>
	    </td>
	</tr>
	<tr>
		<td align='right'>
		  <a href="javascript:window.close();" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_close.gif"  align="absmiddle" border="0"></a>
		</td>	
	</tr>	
</table>
</form>  
</body>
</html>
