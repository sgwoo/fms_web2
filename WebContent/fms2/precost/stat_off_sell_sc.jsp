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
	
	int mons 	= 12;
	
	Vector vt = ad_db.getStatOffSellMon(s_yy);
	int vt_size = vt.size();
	
	int s1_row = 0;
	int d1_row = 0;
	int j1_row = 0;
	int g1_row = 0;
	int b1_row = 0;
	
	int t_cnt1[]	 		= new int[mons+1];
	int t_cnt2[]	 		= new int[mons+1];
	int t_cnt3[]	 		= new int[mons+1];
	int t_cnt4[]	 		= new int[mons+1];
	int t_cnt5[]	 		= new int[mons+1];
	int t_amt1[]	 		= new int[mons+1];
	int t_amt2[]	 		= new int[mons+1];
	int t_amt3[]	 		= new int[mons+1];
	int t_amt4[]	 		= new int[mons+1];
	int t_amt5[]	 		= new int[mons+1];
	
	
	for(int i = 0 ; i < vt_size ; i++){
		Hashtable ht = (Hashtable)vt.elementAt(i);
		if(String.valueOf(ht.get("BR_NM")).equals("영남")){
			if(!String.valueOf(ht.get("ST")).equals("탁송") && !String.valueOf(ht.get("ST")).equals("소계")){
				for (int j = 0 ; j < mons+1 ; j++){
					t_cnt1[j] = t_cnt1[j] + AddUtil.parseInt((String)ht.get("CNT"+(j)));
					t_amt1[j] = t_amt1[j] + AddUtil.parseInt((String)ht.get("AMT"+(j)));
				}
			}
			s1_row++;
		}
		if(String.valueOf(ht.get("BR_NM")).equals("대전")){
			if(!String.valueOf(ht.get("ST")).equals("탁송") && !String.valueOf(ht.get("ST")).equals("소계")){
				for (int j = 0 ; j < mons+1 ; j++){
					t_cnt2[j] = t_cnt2[j] + AddUtil.parseInt((String)ht.get("CNT"+(j)));
					t_amt2[j] = t_amt2[j] + AddUtil.parseInt((String)ht.get("AMT"+(j)));
				}
			}
			d1_row++;
		}
		if(String.valueOf(ht.get("BR_NM")).equals("광주")){ 
			if(!String.valueOf(ht.get("ST")).equals("탁송") && !String.valueOf(ht.get("ST")).equals("소계")){
				for (int j = 0 ; j < mons+1 ; j++){
					t_cnt3[j] = t_cnt3[j] + AddUtil.parseInt((String)ht.get("CNT"+(j)));
					t_amt3[j] = t_amt3[j] + AddUtil.parseInt((String)ht.get("AMT"+(j)));
				}
			}
			j1_row++;
		}
		if(String.valueOf(ht.get("BR_NM")).equals("대구")){ 
			if(!String.valueOf(ht.get("ST")).equals("탁송") && !String.valueOf(ht.get("ST")).equals("소계")){
				for (int j = 0 ; j < mons+1 ; j++){
					t_cnt4[j] = t_cnt4[j] + AddUtil.parseInt((String)ht.get("CNT"+(j)));
					t_amt4[j] = t_amt4[j] + AddUtil.parseInt((String)ht.get("AMT"+(j)));
				}
			}
			g1_row++;
		}
		if(String.valueOf(ht.get("BR_NM")).equals("부산")){ 
			if(!String.valueOf(ht.get("ST")).equals("탁송") && !String.valueOf(ht.get("ST")).equals("소계")){
				for (int j = 0 ; j < mons+1 ; j++){
					t_cnt5[j] = t_cnt5[j] + AddUtil.parseInt((String)ht.get("CNT"+(j)));
					t_amt5[j] = t_amt5[j] + AddUtil.parseInt((String)ht.get("AMT"+(j)));
				}
			}
			b1_row++;
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
  <table border="0" cellspacing="0" cellpadding="0" width=1840>
    <tr>
		  <td class=line2 ></td>
	  </tr>
    <tr>
      <td class=line>
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr align="center"> 
            <td colspan="2" rowspan='2' class=title>구분</td>
            <td colspan='2' class=title>합계</td>
					  <%for (int j = 0 ; j < mons ; j++){%>
            <td colspan='2' width=60 class=title><%=j+1%>월</td>
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
              	<%if(String.valueOf(ht.get("BR_NM")).equals("영남")){%>rowspan='<%=s1_row+1%>'<%}%>
              	<%if(String.valueOf(ht.get("BR_NM")).equals("대전")){%>rowspan='<%=d1_row+1%>'<%}%>
              	<%if(String.valueOf(ht.get("BR_NM")).equals("광주")){%>rowspan='<%=j1_row+1%>'<%}%>
              	<%if(String.valueOf(ht.get("BR_NM")).equals("대구")){%>rowspan='<%=g1_row+1%>'<%}%>
              	<%if(String.valueOf(ht.get("BR_NM")).equals("부산")){%>rowspan='<%=b1_row+1%>'<%}%>              	
              ><%=ht.get("BR_NM")%></td>
            <%}%>
            <%if((i+1)==vt_size){%>
            <td align="center" colspan='2'><%=ht.get("ST")%></td>
            <%}else{%>
            <td width="100" align="center"><%=ht.get("ST")%></td>
            <%}%>            
            <%	for (int j = 0 ; j < mons+1 ; j++){%>
            <td align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("CNT"+(j))))%></td>
            <td align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("AMT"+(j))))%></td>                        
					  <%	}%>
          </tr>
          
          <%if(String.valueOf(ht.get("BR_NM")).equals("영남") && i==s1_row-3){%>
          <tr>
          	<td align="center">용품 소계</td>
            <%	for (int j = 0 ; j < mons+1 ; j++){%>
            <td align="right"><%=AddUtil.parseDecimal(t_cnt1[j])%></td>
            <td align="right"><%=AddUtil.parseDecimal(t_amt1[j])%></td>
					  <%	}%>
          </tr>
          <%}%>
          <%if(String.valueOf(ht.get("BR_NM")).equals("대전") && i==s1_row+d1_row-3){%>
          <tr>
          	<td align="center">용품 소계</td>
            <%	for (int j = 0 ; j < mons+1 ; j++){%>
            <td align="right"><%=AddUtil.parseDecimal(t_cnt2[j])%></td>
            <td align="right"><%=AddUtil.parseDecimal(t_amt2[j])%></td>
					  <%	}%>
          </tr>
          <%}%>
          <%if(String.valueOf(ht.get("BR_NM")).equals("광주") && i==s1_row+d1_row+j1_row-3){%>
          <tr>
          	<td align="center">용품 소계</td>
            <%	for (int j = 0 ; j < mons+1 ; j++){%>
            <td align="right"><%=AddUtil.parseDecimal(t_cnt3[j])%></td>
            <td align="right"><%=AddUtil.parseDecimal(t_amt3[j])%></td>
					  <%	}%>
          </tr>
          <%}%>
          <%if(String.valueOf(ht.get("BR_NM")).equals("대구") && i==s1_row+d1_row+j1_row+g1_row-3){%>
          <tr>
          	<td align="center">용품 소계</td>
            <%	for (int j = 0 ; j < mons+1 ; j++){%>
            <td align="right"><%=AddUtil.parseDecimal(t_cnt4[j])%></td>
            <td align="right"><%=AddUtil.parseDecimal(t_amt4[j])%></td>
					  <%	}%>
          </tr>
          <%}%>
          <%if(String.valueOf(ht.get("BR_NM")).equals("부산") && i==s1_row+d1_row+j1_row+g1_row+b1_row-3){%>
          <tr>
          	<td align="center">용품 소계</td>
            <%	for (int j = 0 ; j < mons+1 ; j++){%>
            <td align="right"><%=AddUtil.parseDecimal(t_cnt5[j])%></td>
            <td align="right"><%=AddUtil.parseDecimal(t_amt5[j])%></td>
					  <%	}%>
          </tr>
          <%}%>

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
