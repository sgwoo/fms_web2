<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=popup_asset_excel_j.xls");
%>

<%@ page import="java.util.*, acar.asset.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
</script>

<body>
<%  String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String st 	= request.getParameter("st")==null?"1":request.getParameter("st");
	String gubun 		= request.getParameter("gubun")==null?"car_no":request.getParameter("gubun");
	String gubun_nm 	= request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	
	String st_nm = "";
	
	if (st.equals("1") ) {
		st_nm = "리스차량";
	} else {
		st_nm = "렌트차량";
	}
	
	
	AssetDatabase a_db = AssetDatabase.getInstance();
	
	Vector vt = new Vector();
	
	vt = a_db.getAssetList_j(st, gubun, gubun_nm);

	int cont_size = vt.size();
	
	long t_amt1[] = new long[1];  //기초가액
    long t_amt2[] = new long[1];  //당기 증가
    long t_amt3[] = new long[1];  //충당금 증가
    long t_amt4[] = new long[1];  // 당기 감소
    long t_amt5[] = new long[1];  //충당금 감소
    long t_amt6[] = new long[1];  //전기말 충당금
    long t_amt7[] = new long[1];  //당기말의 장부가액
    long t_amt8[] = new long[1];
    long t_amt9[] = new long[1];
    long t_amt10[] = new long[1];  //매각액
    long t_amt11[] = new long[1];  //구매보조금 
    long t_amt12[] = new long[1]; //전기말 구매보조금  
    long t_amt13[] = new long[1]; //당기말 구매보조금  
      long t_amt14[] = new long[1]; //구매보조금 감소 
        long t_amt15[] = new long[1]; //구매보조금 증가 
    
    String ass_dt = "";
	
%>
<table border="1" cellspacing="0" cellpadding="0" width=2200>
  <tr> 
    <td colspan="25" align="left"><font face="돋움" size="4" > 
      <b>구분: <%=st_nm%> </b> </font></td>
  </tr>
  <tr align="center"> 
   	
	 <td width='5%' >연번</td>
    <td width='9%' >자산코드</td>
    <td width='23%' >자산명</td>
    <td width='15%' >차량번호</td>
    <td width="7%" >취득일자</td>
    <td width="3%" >내용연수</td>
    <td width="4%"  >상각율</td>
    <td width="8%" >기초가액</td>
	<td width="8%" >전기말충당금</td>	
	<td width="8%" >전기말구매보조금</td>	
	<td width="8%" >당기증가</td>	
	<td width="8%" >구매보조금증가</td>	
	<td width="8%" >충당금증가</td>			  
	<td width='8%' >당기감소</td>
	<td width='8%' >충당금감소</td>
	<td width='7%' >보조금감소</td>
	<td width="8%" >일반상각액</td>		
	<td width="7%" >구매보조금</td>		
	<td width="8%" >당기말충당금</td>
	<td width="7%" >당기말구매보조금</td>		 
	<td width="8%" >당기말장부가액</td>	
	<td width="3%" >진행</td>
	<td width="8%" >처분일자</td>
	<td width="8%" >처분금액</td>
   <td width="3%" >양수차량</td>
   
   </tr>
  <%
   	if(cont_size > 0){
		for(int i = 0 ; i < cont_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);		
						
			long t1=0;
			long t2=0;
			long t3=0;
			long t4=0;
			long t5=0;
			long t6=0;
			long t7=0;
			long t8=0;
			long t9=0;
			long t10=0;
			long t11=0;  //구매보조금상각액 
			long t12=0;  //전기말 구매보조금 
			long t13=0;  //당기말 구매보조금 
			long t14=0;  // 구매보조금 감소  
			long t15=0;  // 구매보조금 증가 
											
			if (String.valueOf(ht.get("GET_DATE")).substring(0,4).equals(String.valueOf(ht.get("GISU")))) {
			  t1 = 0;
			  t2 = AddUtil.parseLong(String.valueOf(ht.get("GET_AMT")))+ AddUtil.parseLong(String.valueOf(ht.get("BOOK_DR")));
         	} else {
              t1 = AddUtil.parseLong(String.valueOf(ht.get("GET_AMT")));
              t2 = AddUtil.parseLong(String.valueOf(ht.get("BOOK_DR")));
         	} 
			
									
			t4=AddUtil.parseLong(String.valueOf(ht.get("BOOK_CR")));
			t6=AddUtil.parseLong(String.valueOf(ht.get("JUN_RESER")));
			t8=AddUtil.parseLong(String.valueOf(ht.get("DEP_AMT")));
			
			t10=AddUtil.parseLong(String.valueOf(ht.get("SUP_AMT")));
			t11=AddUtil.parseLong(String.valueOf(ht.get("GDEP_MAMT")));   //구매보조금 상각액
			t12=AddUtil.parseLong(String.valueOf(ht.get("JUN_GDEP")));   //전기말 구매보조금
			t13=AddUtil.parseLong(String.valueOf(ht.get("GDEP_AMT")));   //당기말 구매보조금
			
				
		   if ( AddUtil.parseLong(String.valueOf(ht.get("GOV_DATE")))  > 0  ) {
			
				if (String.valueOf(ht.get("GOV_DATE")).substring(0,4).equals(String.valueOf(ht.get("GISU")))) {		
				  t15 = AddUtil.parseLong(String.valueOf(ht.get("GOV_AMT"))) ;
				  t15 = t15*(-1);
	         	} else {
	            t15 =0;
	            
	         	} 
		   }	 
		   		   			
			if ( ht.get("DEPRF_YN").equals("5")) {
				t5=AddUtil.parseLong(String.valueOf(ht.get("JUN_RESER")))+ AddUtil.parseLong(String.valueOf(ht.get("DEP_AMT")));
				t7 = 0;
				t9 = 0;
				t14 = AddUtil.parseLong(String.valueOf(ht.get("GDEP_AMT")));	
				t13 = 0;
			} else {
				t7 = t1 + t2 - t6 - t8 - t13;
				t9 = t6 + t8;
				t13 = t13;  // t6  - t11
			}
			
					
			for(int j=0; j<1; j++){
			
					t_amt1[j] += t1;
					t_amt2[j] += t2;
					t_amt3[j] += t3;
					t_amt4[j] += t4;
					t_amt5[j] += t5;
					t_amt6[j] += t6;
					t_amt7[j] += t7;
					t_amt8[j] += t8;
					t_amt9[j] += t9;
					t_amt10[j] += t10;
					t_amt11[j] += t11;
					t_amt12[j] += t12;
					t_amt13[j] += t13;
					t_amt14[j] += t14;
					t_amt15[j] += t15;
													
			}
		
		%>			
  <tr> 
   
	 <td width='5%' align='center'><%=i+1%></td>
     <td width='9%' align='center'><%=ht.get("ASSET_CODE")%></td>
     <td width='23%' align='center'>&nbsp;<%=ht.get("ASSET_NAME")%></td>
     <td width='15%' align='center'><%=ht.get("CAR_NO")%></td>		
     <td width='7%' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("GET_DATE")))%></td>
     <td width='3%' align='center'><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht.get("LIFE_EXIST"))), 1) %></td>
     <td width="4%" align='right'><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht.get("NDEPRE_RATE"))), 3) %>&nbsp;</td>
     <td width='8%' align='right'><%=Util.parseDecimal(t1)%></td>
	 <td width='8%' align='right'><%=Util.parseDecimal(t6)%></td>		
	  <td width='8%' align='right'><%=Util.parseDecimal(t12)%></td>		
	 <td width='8%' align='right'><%=Util.parseDecimal(t2)%></td>		
	 <td width='8%' align='right'><%=Util.parseDecimal(t15)%></td>							
	 <td width='8%' align='right'><%=Util.parseDecimal(t3)%></td>
	 <td width='8%' align='right'><%=Util.parseDecimal(t4)%></td>
	 <td width='8%' align='right'><%=Util.parseDecimal(t5)%></td>
	  <td width='7%' align='right'><%=Util.parseDecimal(t14)%></td>
	 <td width='8%' align='right'><%=Util.parseDecimal(t8)%></td>	
	 <td width='7%' align='right'><%=Util.parseDecimal(t11)%></td>
	 <td width='8%' align='right'><%=Util.parseDecimal(t9)%></td>	
	 <td width='7%' align='right'><%=Util.parseDecimal(t13)%></td>		  
	 <td width='8%' align='right'><%=Util.parseDecimal(t7)%></td>
	 
	 <td width='8%' align='right'>
    <%    if (ht.get("DEPRF_YN").equals("1")){%>불가 <%}else if( ht.get("DEPRF_YN").equals("2")){%>진행  <%}else if( ht.get("DEPRF_YN").equals("4")){%>완료  <%}else if( ht.get("DEPRF_YN").equals("5")){%>처분 <%}else if( ht.get("DEPRF_YN").equals("6")){%>처분 <%}%>&nbsp;  
   </td> 
    <td>
    <% if ( ht.get("DEPRF_YN").equals("5") || ht.get("DEPRF_YN").equals("6") ) {
         ass_dt = a_db.getMove_dt(String.valueOf(ht.get("ASSET_CODE")));
     }  %>    
    <%=ass_dt%>       
    </td>
    <td><%=Util.parseDecimal(t10)%></td> 
    <td> <% if ( ht.get("CAR_GU").equals("2")  ) {%><%=ht.get("DLV_DT")%><%    }  %>   </td> 
  </tr>
<%		}	
 }
%>
  <tr>   
    <td colspan=7 align="center">총합계</td>
    <td><%=Util.parseDecimal(t_amt1[0])%></td>
	<td><%=Util.parseDecimal(t_amt6[0])%></td>	
	<td><%=Util.parseDecimal(t_amt12[0])%></td>	
	<td><%=Util.parseDecimal(t_amt2[0])%></td>					
	<td><%=Util.parseDecimal(t_amt15[0])%></td>					
	<td><%=Util.parseDecimal(t_amt3[0])%></td>
	<td><%=Util.parseDecimal(t_amt4[0])%></td>
	<td><%=Util.parseDecimal(t_amt5[0])%></td>
	<td><%=Util.parseDecimal(t_amt14[0])%></td>		  
	<td><%=Util.parseDecimal(t_amt8[0])%></td>		  
	<td><%=Util.parseDecimal(t_amt11[0])%></td>		  
	<td><%=Util.parseDecimal(t_amt9[0])%></td>		
	<td><%=Util.parseDecimal(t_amt13[0])%></td>		
	<td><%=Util.parseDecimal(t_amt7[0])%></td>	
	<td></td>
	<td></td>
	<td><%=Util.parseDecimal(t_amt10[0])%></td>
	<td></td>
  </tr>
</table>
</body>
</html>
