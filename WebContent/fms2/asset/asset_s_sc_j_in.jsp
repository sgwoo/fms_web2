<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.asset.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String st 	= request.getParameter("st")==null?"1":request.getParameter("st");
	String gubun 		= request.getParameter("gubun")==null?"car_no":request.getParameter("gubun");
	String gubun_nm 	= request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	
		
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;

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
    long t_amt8[] = new long[1]; //상각액
    long t_amt9[] = new long[1]; 
    long t_amt10[] = new long[1];
    long t_amt11[] = new long[1];  // 구매보조금 
    long t_amt12[] = new long[1]; //전기말 구매보조금  
    long t_amt13[] = new long[1]; //당기말 구매보조금  
    long t_amt14[] = new long[1]; //구매보조금 감소 
    long t_amt15[] = new long[1]; //구매보조금 증가 
  	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--
	/* Title 고정 */
	function setupEvents(){
		window.onscroll = moveTitle ;
		window.onresize = moveTitle ; 
	}
	
	function moveTitle(){
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    	    
	}
	
	function init(){		
		setupEvents();
	}	
//-->
</script>
</head>
<body onLoad="javascript:init()">
<table border="0" cellspacing="0" cellpadding="0" width='2100'>
  <tr>
   	<td colspan=2 class=line2></td>
   </tr> 
  <tr id='tr_title' style='position:relative;z-index:1' >		
    <td class='line' width='27%' id='td_title' style='position:relative;' > 
	  <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr> 
          <td width='7%' class='title'>연번</td>
          <td width='12%' class='title'>자산코드</td>
          <td width='28%' class='title'>자산명</td>
          <td width='18%' class='title'>차량번호</td>
          <td width="15%" class='title'>취득일자</td>
          <td width="11%" class='title'>내용연수</td>
          <td width="9%" class='title'>상각율</td>
        </tr>
      </table>
	</td>
	<td class='line' width='73%' >
	  <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>		
	      <td width="7%" class='title'>기초가액</td>
		  <td width="7%" class='title'>전기말충당금</td>	
		  <td width="7%" class='title'>전기말구매보조금</td>	
		  <td width="7%" class='title'>당기증가</td>	
		  <td width="7%" class='title'>보조금증가</td>	
		  <td width="7%" class='title'>충당금증가</td>			  
	      <td width='7%' class='title'>당기감소</td>
	      <td width='7%' class='title'>충당금감소</td>
	      <td width='6%' class='title'>보조금감소</td>
	      <td width="7%" class='title'>일반상각액</td>		
	      <td width="6%" class='title'>구매보조금</td>		
	      <td width="7%" class='title'>당기말충당금</td>		 
	      <td width="7%" class='title'>당기말구매보조금</td>		 
	      <td width="7%" class='title'>당기말장부가액</td>	
	      <td width="4%" class='title'>상태</td>
	      
	   	 
		</tr>
	  </table>
	</td>
  </tr>
  <%if(cont_size > 0){%>
  <tr>		
    <td class='line' width='27%' id='td_con' style='position:relative;'> 
	  <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <%	for(int i = 0 ; i < cont_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				String td_color = "";
				if(!String.valueOf(ht.get("DEPRF_YN")).equals("2")) td_color = "class='is'";%>
        <tr> 
          <td <%=td_color%> width='7%' align='center'><%=i+1%></td>
          <td <%=td_color%> width='12%' align='center'><a href="javascript:parent.view_asset('<%=ht.get("ASSET_CODE")%>')" onMouseOver="window.status=''; return true"><%=ht.get("ASSET_CODE")%></a></td>
          <td <%=td_color%> width='28%' align='center'><span title='<%=String.valueOf(ht.get("ASSET_NAME"))%>'><%=Util.subData(String.valueOf(ht.get("ASSET_NAME")), 12)%></span></td>
          <td <%=td_color%> width='18%' align='center'><%=ht.get("CAR_NO")%></td>		
          <td <%=td_color%> width='15%' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("GET_DATE")))%></td>
          <td <%=td_color%> width='11%' align='center'><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht.get("LIFE_EXIST"))), 1)%></td>
          <td <%=td_color%> width="9%" align='right'><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht.get("NDEPRE_RATE"))), 3) %>&nbsp;</td>
       
        </tr>
        <%		}	%>
        <tr> 
           <td class=title style='text-align:center;' colspan="7" >합계</td>
         </tr>
      </table>
	</td>
	<td class='line' width='73%'> 
	  <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <%	for(int i = 0 ; i < cont_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				
				String td_color = "";
				if(!String.valueOf(ht.get("DEPRF_YN")).equals("2")) td_color = "class='is'";
				
							
				long t1=0;
				long t2=0;
				long t3=0;
				long t4=0;
				long t5=0;
				long t6=0;
				long t7=0;
				long t8=0;
				long t9=0;
				long t10=0;  //매각액  
				long t11=0;  //구매보조금 
				long t12=0;  //전기말구매보조금
				long t13=0;  //당기말 구매보조금
				long t14=0;  //구매보조금감소 
				long t15=0;  //구매보조금증가 
												
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
				t11=AddUtil.parseLong(String.valueOf(ht.get("GDEP_MAMT")));   //구매보조금 
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
					t13 =0;
				} else {
				
					t7 = t1 + t2 - t6 - t8  - t13;
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
						t_amt11[j] += t11;
						t_amt12[j] += t12;
						t_amt13[j] += t13;
						t_amt14[j] += t14;
						t_amt15[j] += t15;
														
				}
				
		%>
		<tr>
		
		   <td <%=td_color%>  width="7%" align='right'><%=Util.parseDecimal(t1)%></td> <!-- 기초가액 -->
		  <td <%=td_color%>  width="7%" align='right'><%=Util.parseDecimal(t6)%></td>	<!-- 전기말 충당금 -->	
		  <td <%=td_color%>  width="7%" align='right'><%=Util.parseDecimal(t12)%></td> <!--전기말 구매보조금 -->		
		  <td <%=td_color%>  width="7%" align='right'><%=Util.parseDecimal(t2)%></td>	<!-- 당기증가 -->		
		  <td <%=td_color%>  width="7%" align='right'><%=Util.parseDecimal(t15)%></td>  <!-- 보조금 증가 -->		
		  <td <%=td_color%>  width="7%" align='right'><%=Util.parseDecimal(t3)%></td>  <!-- 당기 충당금 증가 -->
		  <td <%=td_color%>  width="7%" align='right'><%=Util.parseDecimal(t4)%></td>   <!--당기 감소 -->
		  <td <%=td_color%>  width='7%' align='right'><%=Util.parseDecimal(t5)%></td>   <!-- 당기 충당금 감소 -->
		  <td <%=td_color%> width='6%' align='right'><%=Util.parseDecimal(t14)%></td>   <!-- 당기 보조금 감소 -->
		  <td <%=td_color%>  width='7%' align='right'><%=Util.parseDecimal(t8)%></td>	<!-- 일반상각액 -->
		  <td <%=td_color%>  width='6%' align='right'><%=Util.parseDecimal(t11)%></td>  <!-- 구매보조금 -->
		  <td <%=td_color%>  width='7%' align='right'><%=Util.parseDecimal(t9)%></td>	 <!-- 당기말 충당금 -->
		  <td <%=td_color%>  width='7%' align='right'><%=Util.parseDecimal(t13)%></td>	 <!--당기말 구매보조금  -->
		  <td <%=td_color%>  width='7%' align='right'><%=Util.parseDecimal(t7)%></td>  <!-- 장부가액 -->
		  <td <%=td_color%> width='4%' align='right'>
     <%    if (ht.get("DEPRF_YN").equals("1")){%>불가 <%}else if( ht.get("DEPRF_YN").equals("2")){%>진행  <%}else if( ht.get("DEPRF_YN").equals("4")){%>완료  <%}else if( ht.get("DEPRF_YN").equals("5")){%>처분 <%}else if( ht.get("DEPRF_YN").equals("6")){%>처분 <%}%>&nbsp;  
		  </td>
			
		</tr>
<%		}	%>
		<tr>
		 <td class=title style='text-align:right;'><%=Util.parseDecimal(t_amt1[0])%></td>
		  <td class=title style='text-align:right;'><%=Util.parseDecimal(t_amt6[0])%></td>	
		  <td class=title style='text-align:right;'><%=Util.parseDecimal(t_amt12[0])%></td>		
		  <td class=title style='text-align:right;'><%=Util.parseDecimal(t_amt2[0])%></td>		
		  <td class=title style='text-align:right;'><%=Util.parseDecimal(t_amt15[0])%></td>	  			
		  <td class=title style='text-align:right;'><%=Util.parseDecimal(t_amt3[0])%></td>
		  <td class=title style='text-align:right;'><%=Util.parseDecimal(t_amt4[0])%></td>
		  <td class=title style='text-align:right;'><%=Util.parseDecimal(t_amt5[0])%></td>
		  <td class=title style='text-align:right;'><%=Util.parseDecimal(t_amt14[0])%></td>
		  <td class=title style='text-align:right;'><%=Util.parseDecimal(t_amt8[0])%></td>		 
		  <td class=title style='text-align:right;'><%=Util.parseDecimal(t_amt11[0])%></td>		 
		  <td class=title style='text-align:right;'><%=Util.parseDecimal(t_amt9[0])%></td>		
		  <td class=title style='text-align:right;'><%=Util.parseDecimal(t_amt13[0])%></td>		
		  <td class=title style='text-align:right;'><%=Util.parseDecimal(t_amt7[0])%></td>
		  <td class=title style='text-align:right;'></td>
			
		</tr>
	  </table>
	</td>
<%	}else{	%>                     
  <tr>		
    <td class='line' width='27%' id='td_con' style='position:relative;'> 
	  <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr> 
          <td align='center'><%if(st.equals("")){%>검색어를 입력하십시오.<%}else{%>등록된 데이타가 없습니다<%}%></td>
        </tr>
      </table>
	</td>
	<td class='line' width='73%'>			
      <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr>
		  <td>&nbsp;</td>
		</tr>
  	  </table>
	</td>
  </tr>
<%	}	%>
</table>
<script language='javascript'>
<!--
	parent.document.form1.size.value = '<%=cont_size%>';
//-->
</script>
<form action="./assetma_frame.jsp" name="form1" method="POST">
<input type="hidden" name="st" value="<%=st%>">
<input type="hidden" name="gubun" value="<%=gubun%>">
<input type="hidden" name="gubun_nm" value="<%=gubun_nm%>">
</form>
</body>
</html>


