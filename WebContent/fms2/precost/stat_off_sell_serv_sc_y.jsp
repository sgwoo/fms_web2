<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String s_yy 	= request.getParameter("s_yy")==null?"":request.getParameter("s_yy");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	
	int f_year 	= 2017;	
	int days 	= 0;
	int mons 	= 12;
	int years 	= AddUtil.getDate2(1)-f_year+1;
	
	mons = years;
	
	Vector vt = ad_db.getStatOffSellServMon(s_yy, gubun1);

	int vt_size = vt.size();
	
	int s1_row = 0;
	int d1_row = 0;
	int j1_row = 0;
	int g1_row = 0;
	int b1_row = 0;
	int x1_row = 0;
	int t1_row = 0;  //타이어
	int z1_row = 0;  //긴급출동
	
	
	for(int i = 0 ; i < vt_size ; i++){
		Hashtable ht = (Hashtable)vt.elementAt(i);
		if(String.valueOf(ht.get("BR_NM")).equals("본사")){
			s1_row++;
		}
		if(String.valueOf(ht.get("BR_NM")).equals("대전")){
			d1_row++;
		}
		if(String.valueOf(ht.get("BR_NM")).equals("광주")){ 
			j1_row++;
		}
		if(String.valueOf(ht.get("BR_NM")).equals("대구")){ 
			g1_row++;
		}
		if(String.valueOf(ht.get("BR_NM")).equals("부산")){ 
			b1_row++;
		}
		if(String.valueOf(ht.get("BR_NM")).equals("경정비")){ 
			x1_row++;
		}
		if(String.valueOf(ht.get("BR_NM")).equals("타이어")){ 
			t1_row++;
		}
		if(String.valueOf(ht.get("BR_NM")).equals("긴급출동")){ 
			z1_row++;
		}
		
	}

%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
  <table border="0" cellspacing="0" cellpadding="0" width=1890>
    <tr>
		  <td class=line2 ></td>
	  </tr>
    <tr>
      <td class=line>
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr align="center"> 
            <td colspan="2" rowspan='2' class=title>구분</td>
            <td colspan='2' class=title>합계</td>
					  <%for (int i = f_year ; i <= AddUtil.getDate2(1) ; i++){%>
            <td colspan='2' width=60 class=title><%=i%>년도</td>
					  <%}%>
          </tr>
          <tr align="center"> 
            <td width=50 class=title>건수</td>
            <td width=80 class=title>금액</td>
					  <%for (int j = 0 ; j < mons ; j++){%>
            <td width=50 class=title>건수</td>
            <td width=80 class=title>금액</td>
					  <%}%>
          </tr>
				  <%
				  	String br_nm = "";
				  	for(int i = 0 ; i < vt_size ; i++){
							Hashtable ht = (Hashtable)vt.elementAt(i);
					%>
          <tr> 
            <%if(!String.valueOf(ht.get("BR_NM")).equals(br_nm) && (i+1) < vt_size){%>
              <td width="50" align="center" 
              	<%if(String.valueOf(ht.get("BR_NM")).equals("본사")){%>rowspan='<%=s1_row%>'<%}%>
              	<%if(String.valueOf(ht.get("BR_NM")).equals("대전")){%>rowspan='<%=d1_row%>'<%}%>
              	<%if(String.valueOf(ht.get("BR_NM")).equals("광주")){%>rowspan='<%=j1_row%>'<%}%>
              	<%if(String.valueOf(ht.get("BR_NM")).equals("대구")){%>rowspan='<%=g1_row%>'<%}%>
              	<%if(String.valueOf(ht.get("BR_NM")).equals("부산")){%>rowspan='<%=b1_row%>'<%}%>             
              	<%if(String.valueOf(ht.get("BR_NM")).equals("경정비")){%>rowspan='<%=x1_row%>'<%}%>  
              	<%if(String.valueOf(ht.get("BR_NM")).equals("타이어")){%>rowspan='<%=t1_row%>'<%}%>   
              	<%if(String.valueOf(ht.get("BR_NM")).equals("긴급출동")){%>rowspan='<%=z1_row%>'<%}%>              	           	
              ><%=ht.get("BR_NM")%></td>
            <%}%>
            <%if((i+1)==vt_size){%>
            <td align="center" colspan='2'><%=ht.get("ST")%></td>
            <%}else{%>
            <td width="150" align="center"><span title='<%=ht.get("ST")%>'><%=AddUtil.subData(String.valueOf(ht.get("ST")), 10)%></span></td>
            <%}%>            
            <%//	for (int j = 0 ; j < mons+1 ; j++){%>
            <%	for (int j = (f_year-2000-1) ; j <= (AddUtil.getDate2(1)-2000) ; j++){%>
            <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT"+(j))))%></td>
            <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT"+(j))))%></td>                        
					  <%	}%>
          </tr>
          
					<%	br_nm = String.valueOf(ht.get("BR_NM"));
				    }
				  %>
        </table>
      </td>    
    </tr>
  </table>
</form>
</body>
</html>
