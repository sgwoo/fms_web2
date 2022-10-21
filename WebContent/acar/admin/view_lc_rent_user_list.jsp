<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.admin.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
//-->
</script>
<link rel=stylesheet type="text/css" href="../../include/table_t.css">
<body>
<%
	String st = request.getParameter("st")==null?"":request.getParameter("st");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	int total_su = 0;
	long total_amt = 0;
	long total_amt2 = 0;
	long total_amt3 = 0;
	long total_amt4 = 0;
	
	
	
	Vector vts = new Vector();
	int vt_size = 0;
	
	vts = ad_db.getLcRentUserList(st, user_id);
	vt_size = vts.size();
	
	//vt_size = 103;
%>
<form name='form1' method='post'>
<input type="hidden" name="vt_size" 			value="<%=vt_size%>">
<table border="0" cellspacing="0" cellpadding="0" width=955>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>고객 리스트</span></td>
    </tr>  
    <tr>
        <td class=line2></td>
    </tr>	
	<tr>
	    <td class=line>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		        <tr valign="middle" align="center">
		          <td width='20' class=title style="font-size:7pt">연번</td>
        		    <td width='100' class=title style="font-size:7pt">고객</td>		  
        		    <td width='65' class=title style="font-size:7pt">차량번호</td>		  			
        		    <td width="70" class=title style="font-size:7pt">차명</td>
        		    <td width="30" class=title style="font-size:7pt">관리<br>구분</td>
        		    <td width="50" class=title style="font-size:7pt">계약만료일</td>					
        	        <td width='90' class=title style="font-size:7pt">연락처</td>
        	        <td width="85" class=title style="font-size:7pt">차량이용자</td>
        	        <td width="85" class=title style="font-size:7pt">차량관리자</td>
        		    <td width="85" class=title style="font-size:7pt">회계관리자</td>
        		    <td width="85" class=title style="font-size:7pt">계약담당자</td>
        		    <td width="100" class=title style="font-size:7pt">주소</td>					
        		    <td width="30" class=title style="font-size:7pt">최초<br>영업</td>
        		    <td width="30" class=title style="font-size:7pt">영업<br>담당</td>
		            <td width="30" class=title style="font-size:7pt">관리<br>담당</td>
		        </tr>
				
<%		for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vts.elementAt(i);%>
		        <tr> 
        		    <td style="font-size:7pt" align='center'><%=i+1%></td>
        		    <td style="font-size:7pt" align='center'><%=ht.get("FIRM_NM")%><%if(!String.valueOf(ht.get("FIRM_NM")).equals(String.valueOf(ht.get("CLIENT_NM")))){%><br><%=ht.get("CLIENT_NM")%><%}%></td>
        		    <td style="font-size:7pt" align='center'><%=ht.get("CAR_NO")%></td>			
        		    <td style="font-size:7pt" align='center'><%=ht.get("CAR_NM")%></td>
        		    <td style="font-size:7pt" align='center'><%=ht.get("RENT_WAY")%></td>					
        		    <td style="font-size:7pt" align='center'><%=ht.get("RENT_END_DT")%></td>						
        		    <td style="font-size:7pt" align='center'>
					<%if(!String.valueOf(ht.get("O_TEL")).equals("")){%>O:<%=ht.get("O_TEL")%><br><%}%>
					<%if(!String.valueOf(ht.get("FAX")).equals("")){%>F:<%=ht.get("FAX")%><br><%}%>
					<%if(!String.valueOf(ht.get("M_TEL")).equals("")){%>M:<%=ht.get("M_TEL")%><br><%}%>					
					<%if(!String.valueOf(ht.get("H_TEL")).equals("")){%>H:<%=ht.get("H_TEL")%><%}%>
					</td>
        		    <td style="font-size:7pt" align='center'><%=ht.get("MGR_NM1")%>
					<%if(!String.valueOf(ht.get("MGR_M_TEL1")).equals("")){%><br>M:<%=ht.get("MGR_M_TEL1")%><%}%>
					<%if(!String.valueOf(ht.get("MGR_TEL1")).equals("")){%><br>T:<%=ht.get("MGR_TEL1")%><%}%>
					</td>			
        		    <td style="font-size:7pt" align='center'><%=ht.get("MGR_NM2")%>
					<%if(!String.valueOf(ht.get("MGR_M_TEL2")).equals("")){%><br>M:<%=ht.get("MGR_M_TEL2")%><%}%>
					<%if(!String.valueOf(ht.get("MGR_TEL2")).equals("")){%><br>T:<%=ht.get("MGR_TEL2")%><%}%>
					</td>
        		    <td style="font-size:7pt" align='center'><%=ht.get("MGR_NM3")%>
					<%if(!String.valueOf(ht.get("MGR_M_TEL3")).equals("")){%><br>M:<%=ht.get("MGR_M_TEL3")%><%}%>
					<%if(!String.valueOf(ht.get("MGR_TEL3")).equals("")){%><br>T:<%=ht.get("MGR_TEL3")%><%}%>
					</td>
        		    <td style="font-size:7pt" align='center'><%=ht.get("MGR_NM4")%>
					<%if(!String.valueOf(ht.get("MGR_M_TEL4")).equals("")){%><br>M:<%=ht.get("MGR_M_TEL4")%><%}%>
					<%if(!String.valueOf(ht.get("MGR_TEL4")).equals("")){%><br>T:<%=ht.get("MGR_TEL4")%><%}%>
					</td>
        		    <td style="font-size:7pt" align='center'><%=ht.get("O_ADDR")%>&nbsp;</td>
        		    <td align='center' style="font-size:7pt"><%=ht.get("BUS_NM")%></td>
		            <td align='center' style="font-size:7pt"><%=ht.get("BUS_NM2")%></td>
		            <td align='center' style="font-size:7pt"><%=ht.get("MNG_NM")%></td>					
		        </tr>
  <%		
		  }%>		  
	        </table>
	    </td>
	</tr>
	<tr>
		<td>
			※ M : 핸드폰번호, 
			   O : 사무실전화번호, 
			   F : 팩스번호,
			   H : 자택번호,
			   T : 연락처
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
