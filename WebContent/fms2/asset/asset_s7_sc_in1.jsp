<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.asset.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	//자동차관리 검색 페이지
	
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");

	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"5":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"desc":request.getParameter("asc");
	
//	String chk1 = request.getParameter("chk1")==null?"2":request.getParameter("chk1");
	
	String s_year = request.getParameter("s_year")==null?"":request.getParameter("s_year");	
//	String f_month = request.getParameter("f_month")==null?"":request.getParameter("f_month");
	String t_month = request.getParameter("t_month")==null?"":request.getParameter("t_month");
	
//	System.out.println("t_month="+t_month);
		
//	String f_asset_dt = s_year + f_month + "01";
//	String t_asset_dt = s_year + t_month + "31";	
			
	AssetDatabase as_db = AssetDatabase.getInstance();
	
	Vector vt = new Vector();
		
	vt = as_db.getAssetList(s_kd,t_month );


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
    long t_amt10[] = new long[1]; //매각액  
    long t_amt11[] = new long[1]; //구매보조금  
    long t_amt12[] = new long[1]; //전기말 구매보조금  
    long t_amt13[] = new long[1]; //당기말 구매보조금  
    long t_amt14[] = new long[1]; //구매보조금 감소 
    long t_amt15[] = new long[1]; //구매보조금 증가 
    
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
<body>
<form  name="form1" method="POST">
<table border="0" cellspacing="0" cellpadding="0" width='1900'>
  <tr>
   	<td colspan=2 class=line2></td>
   </tr> 
  <tr id='tr_title' style='position:relative;z-index:1' >		
    <td class='line' width='30%' id='td_title' style='position:relative;' > 
	  <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr> 
          <td width='7%' class='title'>연번</td>
          <td width='12%' class='title'>자산코드</td>
          <td width='28%' class='title'>자산명</td>
          <td width='18%' class='title'>차량번호</td>
          <td width="15%" class='title'>취득일자</td>
        </tr>
      </table>
	</td>
	<td class='line' width='70%' >
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
	      <td width="7%" class='title'>당기말보조금</td>		 
	      <td width="7%" class='title'>당기말장부가액</td>	
	      <td width="4%" class='title'>상태</td> 	      
	    
		</tr>
	  </table>
	</td>
  </tr>
  <%if(cont_size > 0){%>
  <tr>		
    <td class='line' width='30%' id='td_con' style='position:relative;'> 
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
        
        </tr>
        <%		}	%>
        <tr> 
           <td class=title style='text-align:center;' colspan="5" >합계</td>
         </tr>
      </table>
	</td>
	<td class='line' width='70%'> 
	  <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <%	for(int i = 0 ; i < cont_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				
				String td_color = "";
				if(!String.valueOf(ht.get("DEPRF_YN")).equals("2")) td_color = "class='is'";
											
			/*	long t1=0;
				long t2=0;
				long t3=0;
				long t4=0;
				long t5=0;
				long t6=0;
				long t7=0;
				long t8=0;
				long t9=0;
				
				long t12=0;
				long t13=0; */				
				
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
				long t11=0;  //구매보조금상각액 
				long t12=0;  //전기말 구매보조금 
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
				t8=AddUtil.parseLong(String.valueOf(ht.get("DEP_AMT")));  //일반상각액 
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
			   	
					//처분된 건 	
					if ( ht.get("DEPRF_YN").equals("5")) {
						t5=AddUtil.parseLong(String.valueOf(ht.get("JUN_RESER")))+ AddUtil.parseLong(String.valueOf(ht.get("DEP_AMT")));
						t7 = 0;
						t9 = 0;
					   t14 = AddUtil.parseLong(String.valueOf(ht.get("GDEP_AMT")));	
					   t13 = 0;	
					
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
		  <td <%=td_color%>  width="7%" align='right'><%=Util.parseDecimal(t15)%></td>	<!-- 보증금증가 -->				
		  <td <%=td_color%>  width="7%" align='right'><%=Util.parseDecimal(t3)%></td>  <!-- 당기 충당금 증가 -->
		  <td <%=td_color%>  width="7%" align='right'><%=Util.parseDecimal(t4)%></td>   <!--당기 감소 -->
		  <td <%=td_color%>  width='7%' align='right'><%=Util.parseDecimal(t5)%></td>   <!-- 당기 충당금 감소 -->
		  <td <%=td_color%> width='6%' align='right'><%=Util.parseDecimal(t14)%></td>   <!-- 당기 보조금 감소 -->
		  <td <%=td_color%>  width='7%' align='right'><%=Util.parseDecimal(t8)%></td>	<!-- 일반상각액 -->
		  <td <%=td_color%>  width='6%' align='right'><%=Util.parseDecimal(t11)%></td>  <!-- 구매보조금 -->
		  <td <%=td_color%>  width='7%' align='right'><%=Util.parseDecimal(t9)%></td>	 <!-- 당기말 충당금 -->
		  <td <%=td_color%>  width='7%' align='right'><%=Util.parseDecimal(t13)%></td>	 <!--당기말 구매보조금  -->
		  <td <%=td_color%>  width='7%' align='right'><%=Util.parseDecimal(t7)%></td>  <!-- 장부가액 -->
		   <td <%=td_color%>  width="4%" align='right'>
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
    <td class='line' width='30%' id='td_con' style='position:relative;'> 
	  <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr> 
          <td align='center'>등록된 데이타가 없습니다</td>
        </tr>
      </table>
	</td>
	<td class='line' width='70%'>			
      <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr>
		  <td>&nbsp;</td>
		</tr>
  	  </table>
	</td>
  </tr>
<%	}	%>
</table>

<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="br_id" value="<%=br_id%>">

<input type="hidden" name="gubun1" value="<%=gubun1%>">
<input type="hidden" name="s_kd" value="<%=s_kd%>">
<input type="hidden" name="t_wd" value="<%=t_wd%>">
<input type="hidden" name="sort" value="<%=sort%>">
<input type="hidden" name="asc" value="<%=asc%>">

</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</body>
</html>


