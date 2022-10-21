<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="JsDb" scope="page" class="card.JungSanDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<%
   
  	int i_year = 2014;
		
	String st_year = Integer.toString(i_year);
	
	int vt_size2 = 0;
	Vector vts2 = JsDb.getCardJungOilDtStat(st_year);
	vt_size2 = vts2.size();	
		
	int car_type_cnt = 0;
	int car_type_size1 = 0;
	int car_type_size2 = 0;
	int car_type_size3 = 0;
	int car_type_size4 = 0;
	int car_type_size5 = 0;    // 내근
			

	for(int i = 0 ; i < vt_size2 ; i++){
		Hashtable ht = (Hashtable)vts2.elementAt(i);
		if(String.valueOf(ht.get("GUBUN")).equals("12")) car_type_size1++;
		if(String.valueOf(ht.get("GUBUN")).equals("32")) car_type_size2++;
		if(String.valueOf(ht.get("GUBUN")).equals("21")) car_type_size3++;
		if(String.valueOf(ht.get("GUBUN")).equals("31")) car_type_size4++;
		if(String.valueOf(ht.get("GUBUN")).equals("51")) car_type_size5++;
	}
		
	
	long t_amt1[] 	= new long[6];
	long t_amt2[] 	= new long[6];
	long t_amt3[] 	= new long[6];
	long t_amt4[] 	= new long[6];
	long t_amt5[] 	= new long[6];
	long t_amt6[] 	= new long[6];
	long t_amt7[] 	= new long[6];
	long t_amt8[] 	= new long[6];	
	long t_amt9[] 	= new long[6];
	long t_amt10[] 	= new long[6];
	long t_amt11[] 	= new long[6];
	long t_amt12[] 	= new long[6];
	
	
	long t1_amt1[] 	= new long[6];
	long t1_amt2[] 	= new long[6];
	long t1_amt3[] 	= new long[6];
	long t1_amt4[] 	= new long[6];
	long t1_amt5[] 	= new long[6];
	long t1_amt6[] 	= new long[6];
	long t1_amt7[] 	= new long[6];
	long t1_amt8[] 	= new long[6];	
	long t1_amt9[] 	= new long[6];
	long t1_amt10[] = new long[6];
	long t1_amt11[] = new long[6];
	long t1_amt12[] = new long[6];
		
	long t_amt13[] 	= new long[5];
	long t_amt14[] 	= new long[5];
	long t_amt15[] 	= new long[5];
	
			
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
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
	
	//유류대현황 리스트 이동
	function list_move(gubun3, gubun4)
	{
		var fm = document.form1;
		var url = "";
		fm.gubun3.value = gubun3;		
		fm.gubun4.value = gubun4;	
				
		url = "/fms2/jungsan/stat_oil_mng_frame.jsp";
		fm.action = url;		
		fm.target = 'd_content';	
		fm.submit();						
	}				
//-->
</script>
</head>
<body onLoad="javascript:init()">
<form action="" name="form1" method="POST">

<input type='hidden' name='gubun3' 	value=''>       
<input type='hidden' name='gubun4' 	value=''> 
<input type='hidden' name="s_width" value="<%=s_width%>">   
<input type='hidden' name="s_height" value="<%=s_height%>">    
<input type='hidden' name='st_year' 	value='<%=st_year%>'>       

<table border="0" cellspacing="0" cellpadding="0" width="1650">
	<tr><td class=line2 colspan=2></td></tr>
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td class='line' width='10%' id='td_title' style='position:relative;'> 
	
				<table border="0" cellspacing="1" cellpadding="0" width='100%'  height=43>
          			<tr> 
						<td width='55%' class='title' '>구분</td>						
						<td width='45%' class='title'>성명</td>
					</tr>
				</table>
			</td>
	<td class='line' width='90%'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
         <tr>
            <td  colspan="4"  class='title'>1분기</td>
            <td  colspan="4"  class='title'>2분기</td>
            <td  colspan="4"  class='title'>3분기</td>
            <td  colspan="4"  class='title'>4분기</td>
            <td  colspan="4"  class='title'>합계</td>
          
         </tr>
         <tr>
            <td width='5%' class='title'>업무차량</td>
            <td width='5%' class='title'>예비차량</td>
            <td width='5%' class='title'>고객차량</td>  <!--1분기 -->
            <td width='5%' class='title'>계</td>  <!--1분기 계-->
            <td width='5%' class='title'>업무차량</td>
            <td width='5%' class='title'>예비차량</td>
            <td width='5%' class='title'>고객차량</td>  <!-- 2분기 -->
            <td width='5%' class='title'>계</td>  <!--2분기 계-->
            <td width='5%' class='title'>업무차량</td>
            <td width='5%' class='title'>예비차량</td>
            <td width='5%' class='title'>고객차량</td>  <!-- 3분기 -->
            <td width='5%' class='title'>계</td>  <!--3분기 계-->
            <td width='5%' class='title'>업무차량</td>
            <td width='5%' class='title'>예비차량</td>
            <td width='5%' class='title'>고객차량</td>  <!-- 4분기 -->
            <td width='5%' class='title'>계</td>  <!--4분기 계-->
            <td width='5%' class='title'>업무차량</td>
            <td width='5%' class='title'>예비차량</td>
            <td width='5%' class='title'>고객차량</td>  <!-- 계-->       
            <td width='5%' class='title'>계</td>  <!-- 계-->               
         </tr>
        </table>
	</td>
  </tr>	
  
  <tr>
	  <td class='line' width='10%' id='td_con' style='position:relative;'>
	   <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                  
          <%	car_type_cnt = 0;
          		for (int i = 0 ; i < vt_size2 ; i++){
					Hashtable ht = (Hashtable)vts2.elementAt(i);
					if(String.valueOf(ht.get("GUBUN")).equals("21")){															
			%>	
				
          <tr> 
             <%if(car_type_cnt==0){%>
             <td align="center" width='55%' rowspan='<%=car_type_size3%>'>수도권 1군</td>
		    <%}%>
            <td align="center" width="45%" height="20"><a href="javascript:list_move('11','<%=ht.get("USER_ID")%>');"><%=ht.get("USER_NM")%></a></td>          
          </tr>
           <%						car_type_cnt++;}}%>	
          <tr> 
            <td class="title" align="center"  colspan=2  style='height:44;'>소합계<br>평균</td>            
          </tr>
                 
            <%	car_type_cnt = 0;
          		for (int i = 0 ; i < vt_size2 ; i++){
					Hashtable ht = (Hashtable)vts2.elementAt(i);
					if(String.valueOf(ht.get("GUBUN")).equals("31")){															
			%>	
				
          <tr> 
             <%if(car_type_cnt==0){%>
             <td align="center" width='55%' rowspan='<%=car_type_size4%>'>지점 1군</td>
		    <%}%>
            <td align="center" width="45%" height="20"><a href="javascript:list_move('11','<%=ht.get("USER_ID")%>');"><%=ht.get("USER_NM")%></a></td>          
          </tr>
           <%						car_type_cnt++;}}%>	
          <tr> 
            <td class="title" align="center"  colspan=2  style='height:44;'>소합계<br>평균</td>            
          </tr>
          <%	car_type_cnt = 0;
          		for (int i = 0 ; i < vt_size2 ; i++){
					Hashtable ht = (Hashtable)vts2.elementAt(i);
					if(String.valueOf(ht.get("GUBUN")).equals("12")){				
			%>	
				
          <tr>
            <%if(car_type_cnt==0){%>
             <td align="center" width='55%' rowspan='<%=car_type_size1%>'><!--<a href="javascript:list_move('1','');">-->수도권 2군<!--</a>--></td>
		    <%}%>
            <td align="center" width="45%" height="20"><a href="javascript:list_move('11','<%=ht.get("USER_ID")%>');"><%=ht.get("USER_NM")%></a></td>          
          </tr>
           <%						car_type_cnt++;}}%>	
          <tr> 
            <td class="title" align="center" colspan=2  style='height:44;'>소합계<br>평균</td>           
          </tr>
          
          <%	car_type_cnt = 0;
          		for (int i = 0 ; i < vt_size2 ; i++){
					Hashtable ht = (Hashtable)vts2.elementAt(i);
					if(String.valueOf(ht.get("GUBUN")).equals("32")){						
					
		 %>	
				
          <tr>           
            <%if(car_type_cnt==0){%>
             <td align="center" width='55%' rowspan='<%=car_type_size2%>'>지점 2군</td>
		    <%}%>
            <td align="center" width="45%" height="20"><a href="javascript:list_move('11','<%=ht.get("USER_ID")%>');"><%=ht.get("USER_NM")%></a></td>          
          </tr>
         <%						car_type_cnt++;}}%>	
          <tr> 
            <td class="title" align="center"  colspan=2  style='height:44;'>소합계<br>평균</td>           
          </tr>          
          
           <%	car_type_cnt = 0;
          		for (int i = 0 ; i < vt_size2 ; i++){
					Hashtable ht = (Hashtable)vts2.elementAt(i);
					if(String.valueOf(ht.get("GUBUN")).equals("51")){						
					
	%>	
				
          <tr>           
            <%if(car_type_cnt==0){%>
             <td align="center" width='55%' rowspan='<%=car_type_size5%>'>&nbsp;</td>
		    <%}%>
            <td align="center" width="45%" height="20"><a href="javascript:list_move('11','<%=ht.get("USER_ID")%>');"><%=ht.get("USER_NM")%></a></td>          
          </tr>
         <%						car_type_cnt++;}}%>	
          <tr> 
            <td class="title" align="center"  colspan=2  style='height:44;'>소합계<br>평균</td>           
          </tr>                  
                 
          <tr> 
            <td class="title_p" align="center"  colspan=2  style='height:44;'>총합계<br>평균</td>          
          </tr>
        </table></td>
        
    <td class='line' width='90%'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
       
	<%for (int i = 0 ; i < vt_size2 ; i++){
				Hashtable ht = (Hashtable)vts2.elementAt(i);
				
					if(String.valueOf(ht.get("GUBUN")).equals("21")){	
					
					t_amt1[2] = AddUtil.parseLong(String.valueOf(ht.get("A1_1")));
					t_amt2[2] = AddUtil.parseLong(String.valueOf(ht.get("A1_2")));
				 	t_amt3[2] = AddUtil.parseLong(String.valueOf(ht.get("A1_3")));
					t_amt4[2] = AddUtil.parseLong(String.valueOf(ht.get("A2_1")));
					t_amt5[2] = AddUtil.parseLong(String.valueOf(ht.get("A2_2")));
				         t_amt6[2] = AddUtil.parseLong(String.valueOf(ht.get("A2_3")));
					t_amt7[2] = AddUtil.parseLong(String.valueOf(ht.get("A3_1")));
					t_amt8[2] = AddUtil.parseLong(String.valueOf(ht.get("A3_2")));
					t_amt9[2] = AddUtil.parseLong(String.valueOf(ht.get("A3_3")));
				         t_amt10[2] = AddUtil.parseLong(String.valueOf(ht.get("A4_1")));
					t_amt11[2] = AddUtil.parseLong(String.valueOf(ht.get("A4_2")));
					t_amt12[2] = AddUtil.parseLong(String.valueOf(ht.get("A4_3")));
										
					
		  %>			
          <tr> 
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt1[2])%></td>
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt2[2])%></td>
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt3[2])%></td>
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt1[2]+t_amt2[2]+t_amt3[2])%></td>
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt4[2])%></td>
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt5[2])%></td>
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt6[2])%></td>	
             <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt4[2]+t_amt5[2]+t_amt6[2])%></td>		
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt7[2])%></td>
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt8[2])%></td>
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt9[2])%></td>	
             <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt7[2]+t_amt8[2]+t_amt9[2])%></td>	
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt10[2])%></td>
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt11[2])%></td>
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt12[2])%></td>	
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt10[2]+t_amt11[2]+t_amt12[2])%></td>																		
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt1[2]+t_amt4[2]+t_amt7[2]+t_amt10[2])%></td>
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt2[2]+t_amt5[2]+t_amt8[2]+t_amt11[2])%></td>
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt3[2]+t_amt6[2]+t_amt9[2]+t_amt12[2])%></td>	    	
             <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt1[2]+t_amt4[2]+t_amt7[2]+t_amt10[2]+t_amt2[2]+t_amt5[2]+t_amt8[2]+t_amt11[2]+t_amt3[2]+t_amt6[2]+t_amt9[2]+t_amt12[2])%></td>																														
          </tr>
          <%		
          		  	t1_amt1[2] += AddUtil.parseLong(String.valueOf(ht.get("A1_1")));
					t1_amt2[2] += AddUtil.parseLong(String.valueOf(ht.get("A1_2")));
				 	t1_amt3[2] += AddUtil.parseLong(String.valueOf(ht.get("A1_3")));
					t1_amt4[2] += AddUtil.parseLong(String.valueOf(ht.get("A2_1")));
					t1_amt5[2] += AddUtil.parseLong(String.valueOf(ht.get("A2_2")));
				    t1_amt6[2] += AddUtil.parseLong(String.valueOf(ht.get("A2_3")));
					t1_amt7[2] += AddUtil.parseLong(String.valueOf(ht.get("A3_1")));
					t1_amt8[2] += AddUtil.parseLong(String.valueOf(ht.get("A3_2")));
					t1_amt9[2] += AddUtil.parseLong(String.valueOf(ht.get("A3_3")));
				    t1_amt10[2] += AddUtil.parseLong(String.valueOf(ht.get("A4_1")));
					t1_amt11[2] += AddUtil.parseLong(String.valueOf(ht.get("A4_2")));
					t1_amt12[2] += AddUtil.parseLong(String.valueOf(ht.get("A4_3")));			
					
			} } %>
          <tr> 
            <td class=title style='text-align:right; height=44;' width="5%"><%=Util.parseDecimal(t1_amt1[2])%><br><%=Util.parseDecimal(t1_amt1[2]/car_type_size3)%></td>
             <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt2[2])%><br><%=Util.parseDecimal(t1_amt2[2]/car_type_size3)%></td>
             <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt3[2])%><br><%=Util.parseDecimal(t1_amt3[2]/car_type_size3)%></td>
             <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt1[2]+t1_amt2[2]+t1_amt3[2])%><br><%=Util.parseDecimal(( t1_amt1[2]+t1_amt2[2]+t1_amt3[2])/car_type_size3)%></td>
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt4[2])%><br><%=Util.parseDecimal(t1_amt4[2]/car_type_size3)%></td>
             <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt5[2])%><br><%=Util.parseDecimal(t1_amt5[2]/car_type_size3)%></td>
             <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt6[2])%><br><%=Util.parseDecimal(t1_amt6[2]/car_type_size3)%></td>
           <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt4[2]+t1_amt5[2]+t1_amt6[2])%><br><%=Util.parseDecimal(( t1_amt4[2]+t1_amt5[2]+t1_amt6[2])/car_type_size3)%></td>			
             <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt7[2])%><br><%=Util.parseDecimal(t1_amt7[2]/car_type_size3)%></td>
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt8[2])%><br><%=Util.parseDecimal(t1_amt8[2]/car_type_size3)%></td>
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt9[2])%><br><%=Util.parseDecimal(t1_amt9[2]/car_type_size3)%></td>
             <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt7[2]+t1_amt8[2]+t1_amt9[2])%><br><%=Util.parseDecimal(( t1_amt7[2]+t1_amt8[2]+t1_amt9[2])/car_type_size3)%></td>		
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt10[2])%><br><%=Util.parseDecimal(t1_amt10[2]/car_type_size3)%></td>
             <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt11[2])%><br><%=Util.parseDecimal(t1_amt11[2]/car_type_size3)%></td>
             <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt12[2])%><br><%=Util.parseDecimal(t1_amt12[2]/car_type_size3)%></td>		
             <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt10[2]+t1_amt11[2]+t1_amt12[2])%><br><%=Util.parseDecimal(( t1_amt10[2]+t1_amt11[2]+t1_amt12[2])/car_type_size3)%></td>																	
             <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt1[2]+t1_amt4[2]+t1_amt7[2]+t1_amt10[2])%><br><%=Util.parseDecimal(( t1_amt1[2]+t1_amt4[2]+t1_amt7[2]+t1_amt10[2])/car_type_size3)%></td>
             <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt2[2]+t1_amt5[2]+t1_amt8[2]+t1_amt11[2])%><br><%=Util.parseDecimal(( t1_amt2[2]+t1_amt5[2]+t1_amt8[2]+t1_amt11[2])/car_type_size3)%></td>
             <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt3[2]+t1_amt6[2]+t1_amt9[2]+t1_amt12[2])%><br><%=Util.parseDecimal(( t1_amt3[2]+t1_amt6[2]+t1_amt9[2]+t1_amt12[2])/car_type_size3)%></td>
             <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt1[2]+t1_amt4[2]+t1_amt7[2]+t1_amt10[2]+t1_amt2[2]+t1_amt5[2]+t1_amt8[2]+t1_amt11[2]+t1_amt3[2]+t1_amt6[2]+t1_amt9[2]+t1_amt12[2])%><br><%=Util.parseDecimal((t1_amt1[2]+t1_amt4[2]+t1_amt7[2]+t1_amt10[2]+t1_amt2[2]+t1_amt5[2]+t1_amt8[2]+t1_amt11[2]+t1_amt3[2]+t1_amt6[2]+t1_amt9[2]+t1_amt12[2])/car_type_size3)%></td>	    																															
          </tr>        
          
          	<%for (int i = 0 ; i < vt_size2 ; i++){
				Hashtable ht = (Hashtable)vts2.elementAt(i);
				
					if(String.valueOf(ht.get("GUBUN")).equals("31")){	
					
					t_amt1[3] = AddUtil.parseLong(String.valueOf(ht.get("A1_1")));
					t_amt2[3] = AddUtil.parseLong(String.valueOf(ht.get("A1_2")));
				 	t_amt3[3] = AddUtil.parseLong(String.valueOf(ht.get("A1_3")));
					t_amt4[3] = AddUtil.parseLong(String.valueOf(ht.get("A2_1")));
					t_amt5[3] = AddUtil.parseLong(String.valueOf(ht.get("A2_2")));
				    t_amt6[3] = AddUtil.parseLong(String.valueOf(ht.get("A2_3")));
					t_amt7[3] = AddUtil.parseLong(String.valueOf(ht.get("A3_1")));
					t_amt8[3] = AddUtil.parseLong(String.valueOf(ht.get("A3_2")));
					t_amt9[3] = AddUtil.parseLong(String.valueOf(ht.get("A3_3")));
				    t_amt10[3] = AddUtil.parseLong(String.valueOf(ht.get("A4_1")));
					t_amt11[3] = AddUtil.parseLong(String.valueOf(ht.get("A4_2")));
					t_amt12[3] = AddUtil.parseLong(String.valueOf(ht.get("A4_3")));
										
					
		  %>			
          <tr> 
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt1[3])%></td>
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt2[3])%></td>
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt3[3])%></td>
             <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt1[3]+t_amt2[3]+t_amt3[3])%></td>
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt4[3])%></td>
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt5[3])%></td>
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt6[3])%></td>	
             <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt4[3]+t_amt5[3]+t_amt6[3])%></td>		
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt7[3])%></td>
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt8[3])%></td>
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt9[3])%></td>	
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt7[3]+t_amt8[3]+t_amt9[3])%></td>	
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt10[3])%></td>
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt11[3])%></td>
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt12[3])%></td>	
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt10[3]+t_amt11[3]+t_amt12[3])%></td>																		
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt1[3]+t_amt4[3]+t_amt7[3]+t_amt10[3])%></td>
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt2[3]+t_amt5[3]+t_amt8[3]+t_amt11[3])%></td>
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt3[3]+t_amt6[3]+t_amt9[3]+t_amt12[3])%></td>	
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt1[3]+t_amt4[3]+t_amt7[3]+t_amt10[3]+t_amt2[3]+t_amt5[3]+t_amt8[3]+t_amt11[3]+t_amt3[3]+t_amt6[3]+t_amt9[3]+t_amt12[3])%></td>    																															
          </tr>
          <%		
          		  	t1_amt1[3] += AddUtil.parseLong(String.valueOf(ht.get("A1_1")));
					t1_amt2[3] += AddUtil.parseLong(String.valueOf(ht.get("A1_2")));
				 	t1_amt3[3] += AddUtil.parseLong(String.valueOf(ht.get("A1_3")));
					t1_amt4[3] += AddUtil.parseLong(String.valueOf(ht.get("A2_1")));
					t1_amt5[3] += AddUtil.parseLong(String.valueOf(ht.get("A2_2")));
				    t1_amt6[3] += AddUtil.parseLong(String.valueOf(ht.get("A2_3")));
					t1_amt7[3] += AddUtil.parseLong(String.valueOf(ht.get("A3_1")));
					t1_amt8[3] += AddUtil.parseLong(String.valueOf(ht.get("A3_2")));
					t1_amt9[3] += AddUtil.parseLong(String.valueOf(ht.get("A3_3")));
				    t1_amt10[3] += AddUtil.parseLong(String.valueOf(ht.get("A4_1")));
					t1_amt11[3] += AddUtil.parseLong(String.valueOf(ht.get("A4_2")));
					t1_amt12[3] += AddUtil.parseLong(String.valueOf(ht.get("A4_3")));			
					
			} } %>
          <tr> 
            <td class=title style='text-align:right; height=44;' width="5%"><%=Util.parseDecimal(t1_amt1[3])%><br><%=Util.parseDecimal(t1_amt1[3]/car_type_size4)%></td>
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt2[3])%><br><%=Util.parseDecimal(t1_amt2[3]/car_type_size4)%></td>
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt3[3])%><br><%=Util.parseDecimal(t1_amt3[3]/car_type_size4)%></td>
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt1[3]+t1_amt2[3]+t1_amt3[3])%><br><%=Util.parseDecimal(( t1_amt1[3]+t1_amt2[3]+t1_amt3[3])/car_type_size4)%></td>
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt4[3])%><br><%=Util.parseDecimal(t1_amt4[3]/car_type_size4)%></td>
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt5[3])%><br><%=Util.parseDecimal(t1_amt5[3]/car_type_size4)%></td>
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt6[3])%><br><%=Util.parseDecimal(t1_amt6[3]/car_type_size4)%></td>	
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt4[3]+t1_amt5[3]+t1_amt6[3])%><br><%=Util.parseDecimal(( t1_amt4[3]+t1_amt5[3]+t1_amt6[3])/car_type_size4)%></td>		
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt7[3])%><br><%=Util.parseDecimal(t1_amt7[3]/car_type_size4)%></td>
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt8[3])%><br><%=Util.parseDecimal(t1_amt8[3]/car_type_size4)%></td>
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt9[3])%><br><%=Util.parseDecimal(t1_amt9[3]/car_type_size4)%></td>	
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt7[3]+t1_amt8[3]+t1_amt9[3])%><br><%=Util.parseDecimal(( t1_amt7[3]+t1_amt8[3]+t1_amt9[3])/car_type_size4)%></td>	
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt10[3])%><br><%=Util.parseDecimal(t1_amt10[3]/car_type_size4)%></td>
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt11[3])%><br><%=Util.parseDecimal(t1_amt11[3]/car_type_size4)%></td>
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt12[3])%><br><%=Util.parseDecimal(t1_amt12[3]/car_type_size4)%></td>
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt10[3]+t1_amt11[3]+t1_amt12[3])%><br><%=Util.parseDecimal(( t1_amt10[3]+t1_amt11[3]+t1_amt12[3])/car_type_size4)%></td>																			
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt1[3]+t1_amt4[3]+t1_amt7[3]+t1_amt10[3])%><br><%=Util.parseDecimal(( t1_amt1[3]+t1_amt4[3]+t1_amt7[3]+t1_amt10[3])/car_type_size4)%></td>
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt2[3]+t1_amt5[3]+t1_amt8[3]+t1_amt11[3])%><br><%=Util.parseDecimal(( t1_amt2[3]+t1_amt5[3]+t1_amt8[3]+t1_amt11[3])/car_type_size4)%></td>
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt3[3]+t1_amt6[3]+t1_amt9[3]+t1_amt12[3])%><br><%=Util.parseDecimal(( t1_amt3[3]+t1_amt6[3]+t1_amt9[3]+t1_amt12[3])/car_type_size4)%></td>	  
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt1[3]+t1_amt4[3]+t1_amt7[3]+t1_amt10[3]+t1_amt2[3]+t1_amt5[3]+t1_amt8[3]+t1_amt11[3]+t1_amt3[3]+t1_amt6[3]+t1_amt9[3]+t1_amt12[3])%><br><%=Util.parseDecimal(( t1_amt1[3]+t1_amt4[3]+t1_amt7[3]+t1_amt10[3]+t1_amt2[3]+t1_amt5[3]+t1_amt8[3]+t1_amt11[3]+t1_amt3[3]+t1_amt6[3]+t1_amt9[3]+t1_amt12[3])/car_type_size4)%></td>  																															
          </tr>   
               
       <%for (int i = 0 ; i < vt_size2 ; i++){
				Hashtable ht = (Hashtable)vts2.elementAt(i);
				
					if(String.valueOf(ht.get("GUBUN")).equals("12")){	
					
					t_amt1[0] = AddUtil.parseLong(String.valueOf(ht.get("A1_1")));
					t_amt2[0] = AddUtil.parseLong(String.valueOf(ht.get("A1_2")));
				 	t_amt3[0] = AddUtil.parseLong(String.valueOf(ht.get("A1_3")));
					t_amt4[0] = AddUtil.parseLong(String.valueOf(ht.get("A2_1")));
					t_amt5[0] = AddUtil.parseLong(String.valueOf(ht.get("A2_2")));
				    t_amt6[0] = AddUtil.parseLong(String.valueOf(ht.get("A2_3")));
					t_amt7[0] = AddUtil.parseLong(String.valueOf(ht.get("A3_1")));
					t_amt8[0] = AddUtil.parseLong(String.valueOf(ht.get("A3_2")));
					t_amt9[0] = AddUtil.parseLong(String.valueOf(ht.get("A3_3")));
				    t_amt10[0] = AddUtil.parseLong(String.valueOf(ht.get("A4_1")));
					t_amt11[0] = AddUtil.parseLong(String.valueOf(ht.get("A4_2")));
					t_amt12[0] = AddUtil.parseLong(String.valueOf(ht.get("A4_3")));
										
					
		  %>			
          <tr> 
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt1[0])%></td>
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt2[0])%></td>
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt3[0])%></td>
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt1[0]+t_amt2[0]+t_amt3[0])%></td>
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt4[0])%></td>
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt5[0])%></td>
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt6[0])%></td>	
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt4[0]+t_amt5[0]+t_amt6[0])%></td>		
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt7[0])%></td>
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt8[0])%></td>
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt9[0])%></td>	
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt7[0]+t_amt8[0]+t_amt9[0])%></td>	
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt10[0])%></td>
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt11[0])%></td>
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt12[0])%></td>	
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt10[0]+t_amt11[0]+t_amt12[0])%></td>																		
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt1[0]+t_amt4[0]+t_amt7[0]+t_amt10[0])%></td>
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt2[0]+t_amt5[0]+t_amt8[0]+t_amt11[0])%></td>
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt3[0]+t_amt6[0]+t_amt9[0]+t_amt12[0])%></td>	    
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt1[0]+t_amt4[0]+t_amt7[0]+t_amt10[0]+t_amt2[0]+t_amt5[0]+t_amt8[0]+t_amt11[0]+t_amt3[0]+t_amt6[0]+t_amt9[0]+t_amt12[0])%></td>																															
          </tr>
          <%		
          		  	         t1_amt1[0] += AddUtil.parseLong(String.valueOf(ht.get("A1_1")));
					t1_amt2[0] += AddUtil.parseLong(String.valueOf(ht.get("A1_2")));
				 	t1_amt3[0] += AddUtil.parseLong(String.valueOf(ht.get("A1_3")));
					t1_amt4[0] += AddUtil.parseLong(String.valueOf(ht.get("A2_1")));
					t1_amt5[0] += AddUtil.parseLong(String.valueOf(ht.get("A2_2")));
				         t1_amt6[0] += AddUtil.parseLong(String.valueOf(ht.get("A2_3")));
					t1_amt7[0] += AddUtil.parseLong(String.valueOf(ht.get("A3_1")));
					t1_amt8[0] += AddUtil.parseLong(String.valueOf(ht.get("A3_2")));
					t1_amt9[0] += AddUtil.parseLong(String.valueOf(ht.get("A3_3")));
				         t1_amt10[0] += AddUtil.parseLong(String.valueOf(ht.get("A4_1")));
					t1_amt11[0] += AddUtil.parseLong(String.valueOf(ht.get("A4_2")));
					t1_amt12[0] += AddUtil.parseLong(String.valueOf(ht.get("A4_3")));			
					
			} } %>
          <tr> 
            <td class=title style='text-align:right; height=44;' width="5%"><%=Util.parseDecimal(t1_amt1[0])%><br><%=Util.parseDecimal(t1_amt1[0]/car_type_size1)%></td>
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt2[0])%><br><%=Util.parseDecimal(t1_amt2[0]/car_type_size1)%></td>
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt3[0])%><br><%=Util.parseDecimal(t1_amt3[0]/car_type_size1)%></td>
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt1[0]+t1_amt2[0]+t1_amt3[0])%><br><%=Util.parseDecimal(( t1_amt1[0]+t1_amt2[0]+t1_amt3[0])/car_type_size1)%></td>
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt4[0])%><br><%=Util.parseDecimal(t1_amt4[0]/car_type_size1)%></td>
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt5[0])%><br><%=Util.parseDecimal(t1_amt5[0]/car_type_size1)%></td>
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt6[0])%><br><%=Util.parseDecimal(t1_amt6[0]/car_type_size1)%></td>	
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt4[0]+t1_amt5[0]+t1_amt6[0])%><br><%=Util.parseDecimal(( t1_amt4[0]+t1_amt5[0]+t1_amt6[0])/car_type_size1)%></td>		
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt7[0])%><br><%=Util.parseDecimal(t1_amt7[0]/car_type_size1)%></td>
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt8[0])%><br><%=Util.parseDecimal(t1_amt8[0]/car_type_size1)%></td>
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt9[0])%><br><%=Util.parseDecimal(t1_amt9[0]/car_type_size1)%></td>	
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt7[0]+t1_amt8[0]+t1_amt9[0])%><br><%=Util.parseDecimal(( t1_amt7[0]+t1_amt8[0]+t1_amt9[0])/car_type_size1)%></td>	
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt10[0])%><br><%=Util.parseDecimal(t1_amt10[0]/car_type_size1)%></td>
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt11[0])%><br><%=Util.parseDecimal(t1_amt11[0]/car_type_size1)%></td>
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt12[0])%><br><%=Util.parseDecimal(t1_amt12[0]/car_type_size1)%></td>
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt10[0]+t1_amt11[0]+t1_amt12[0])%><br><%=Util.parseDecimal(( t1_amt10[0]+t1_amt11[0]+t1_amt12[0])/car_type_size1)%></td>																			
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt1[0]+t1_amt4[0]+t1_amt7[0]+t1_amt10[0])%><br><%=Util.parseDecimal(( t1_amt1[0]+t1_amt4[0]+t1_amt7[0]+t1_amt10[0])/car_type_size1)%></td>
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt2[0]+t1_amt5[0]+t1_amt8[0]+t1_amt11[0])%><br><%=Util.parseDecimal(( t1_amt2[0]+t1_amt5[0]+t1_amt8[0]+t1_amt11[0])/car_type_size1)%></td>
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt3[0]+t1_amt6[0]+t1_amt9[0]+t1_amt12[0])%><br><%=Util.parseDecimal(( t1_amt3[0]+t1_amt6[0]+t1_amt9[0]+t1_amt12[0])/car_type_size1)%></td>	    
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt1[0]+t1_amt4[0]+t1_amt7[0]+t1_amt10[0]+t1_amt2[0]+t1_amt5[0]+t1_amt8[0]+t1_amt11[0]+t1_amt3[0]+t1_amt6[0]+t1_amt9[0]+t1_amt12[0])%><br><%=Util.parseDecimal(( t1_amt1[0]+t1_amt4[0]+t1_amt7[0]+t1_amt10[0]+t1_amt2[0]+t1_amt5[0]+t1_amt8[0]+t1_amt11[0]+t1_amt3[0]+t1_amt6[0]+t1_amt9[0]+t1_amt12[0])/car_type_size1)%></td>																															
          </tr>        

	 	<%for (int i = 0 ; i < vt_size2 ; i++){
				Hashtable ht = (Hashtable)vts2.elementAt(i);
				
					if(String.valueOf(ht.get("GUBUN")).equals("32")){	
					
					t_amt1[1] = AddUtil.parseLong(String.valueOf(ht.get("A1_1")));
					t_amt2[1] = AddUtil.parseLong(String.valueOf(ht.get("A1_2")));
				 	t_amt3[1] = AddUtil.parseLong(String.valueOf(ht.get("A1_3")));
					t_amt4[1] = AddUtil.parseLong(String.valueOf(ht.get("A2_1")));
					t_amt5[1] = AddUtil.parseLong(String.valueOf(ht.get("A2_2")));
				    t_amt6[1] = AddUtil.parseLong(String.valueOf(ht.get("A2_3")));
					t_amt7[1] = AddUtil.parseLong(String.valueOf(ht.get("A3_1")));
					t_amt8[1] = AddUtil.parseLong(String.valueOf(ht.get("A3_2")));
					t_amt9[1] = AddUtil.parseLong(String.valueOf(ht.get("A3_3")));
				    t_amt10[1] = AddUtil.parseLong(String.valueOf(ht.get("A4_1")));
					t_amt11[1] = AddUtil.parseLong(String.valueOf(ht.get("A4_2")));
					t_amt12[1] = AddUtil.parseLong(String.valueOf(ht.get("A4_3")));
										
					
		  %>			
          <tr> 
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt1[1])%></td>
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt2[1])%></td>
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt3[1])%></td>
             <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt1[1]+t_amt2[1]+t_amt3[1])%></td>
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt4[1])%></td>
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt5[1])%></td>
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt6[1])%></td>	
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt4[1]+t_amt5[1]+t_amt6[1])%></td>		
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt7[1])%></td>
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt8[1])%></td>
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt9[1])%></td>	
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt7[1]+t_amt8[1]+t_amt9[1])%></td>	
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt10[1])%></td>
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt11[1])%></td>
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt12[1])%></td>	
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt10[1]+t_amt11[1]+t_amt12[1])%></td>																		
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt1[1]+t_amt4[1]+t_amt7[1]+t_amt10[1])%></td>
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt2[1]+t_amt5[1]+t_amt8[1]+t_amt11[1])%></td>
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt3[1]+t_amt6[1]+t_amt9[1]+t_amt12[1])%></td>	   
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt1[1]+t_amt4[1]+t_amt7[1]+t_amt10[1]+t_amt2[1]+t_amt5[1]+t_amt8[1]+t_amt11[1]+t_amt3[1]+t_amt6[1]+t_amt9[1]+t_amt12[1])%></td> 																															
          </tr>
          <%		
          		  	t1_amt1[1] += AddUtil.parseLong(String.valueOf(ht.get("A1_1")));
					t1_amt2[1] += AddUtil.parseLong(String.valueOf(ht.get("A1_2")));
				 	t1_amt3[1] += AddUtil.parseLong(String.valueOf(ht.get("A1_3")));
					t1_amt4[1] += AddUtil.parseLong(String.valueOf(ht.get("A2_1")));
					t1_amt5[1] += AddUtil.parseLong(String.valueOf(ht.get("A2_2")));
				    t1_amt6[1] += AddUtil.parseLong(String.valueOf(ht.get("A2_3")));
					t1_amt7[1] += AddUtil.parseLong(String.valueOf(ht.get("A3_1")));
					t1_amt8[1] += AddUtil.parseLong(String.valueOf(ht.get("A3_2")));
					t1_amt9[1] += AddUtil.parseLong(String.valueOf(ht.get("A3_3")));
				    t1_amt10[1] += AddUtil.parseLong(String.valueOf(ht.get("A4_1")));
					t1_amt11[1] += AddUtil.parseLong(String.valueOf(ht.get("A4_2")));
					t1_amt12[1] += AddUtil.parseLong(String.valueOf(ht.get("A4_3")));			
					
			} } %>
          <tr> 
            <td class=title style='text-align:right; height=44;' width="5%"><%=Util.parseDecimal(t1_amt1[1])%><br><%=Util.parseDecimal(t1_amt1[1]/car_type_size2)%></td>
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt2[1])%><br><%=Util.parseDecimal(t1_amt2[1]/car_type_size2)%></td>
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt3[1])%><br><%=Util.parseDecimal(t1_amt3[1]/car_type_size2)%></td>
             <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt1[1]+t1_amt2[1]+t1_amt3[1])%><br><%=Util.parseDecimal(( t1_amt1[1]+t1_amt2[1]+t1_amt3[1])/car_type_size2)%></td>
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt4[1])%><br><%=Util.parseDecimal(t1_amt4[1]/car_type_size2)%></td>
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt5[1])%><br><%=Util.parseDecimal(t1_amt5[1]/car_type_size2)%></td>
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt6[1])%><br><%=Util.parseDecimal(t1_amt6[1]/car_type_size2)%></td>
             <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt4[1]+t1_amt5[1]+t1_amt6[1])%><br><%=Util.parseDecimal(( t1_amt4[1]+t1_amt5[1]+t1_amt6[1])/car_type_size2)%></td>			
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt7[1])%><br><%=Util.parseDecimal(t1_amt7[1]/car_type_size2)%></td>
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt8[1])%><br><%=Util.parseDecimal(t1_amt8[1]/car_type_size2)%></td>
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt9[1])%><br><%=Util.parseDecimal(t1_amt9[1]/car_type_size2)%></td>	
             <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt7[1]+t1_amt8[1]+t1_amt9[1])%><br><%=Util.parseDecimal(( t1_amt7[1]+t1_amt8[1]+t1_amt9[1])/car_type_size2)%></td>	
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt10[1])%><br><%=Util.parseDecimal(t1_amt10[1]/car_type_size2)%></td>
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt11[1])%><br><%=Util.parseDecimal(t1_amt11[1]/car_type_size2)%></td>
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt12[1])%><br><%=Util.parseDecimal(t1_amt12[1]/car_type_size2)%></td>	
             <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt10[1]+t1_amt11[1]+t1_amt12[1])%><br><%=Util.parseDecimal(( t1_amt10[1]+t1_amt11[1]+t1_amt12[1])/car_type_size2)%></td>																		
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt1[1]+t1_amt4[1]+t1_amt7[1]+t1_amt10[1])%><br><%=Util.parseDecimal(( t1_amt1[1]+t1_amt4[1]+t1_amt7[1]+t1_amt10[1])/car_type_size2)%></td>
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt2[1]+t1_amt5[1]+t1_amt8[1]+t1_amt11[1])%><br><%=Util.parseDecimal(( t1_amt2[1]+t1_amt5[1]+t1_amt8[1]+t1_amt11[1])/car_type_size2)%></td>
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt3[1]+t1_amt6[1]+t1_amt9[1]+t1_amt12[1])%><br><%=Util.parseDecimal(( t1_amt3[1]+t1_amt6[1]+t1_amt9[1]+t1_amt12[1])/car_type_size2)%></td>	   
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt1[1]+t1_amt4[1]+t1_amt7[1]+t1_amt10[1]+t1_amt2[1]+t1_amt5[1]+t1_amt8[1]+t1_amt11[1]+t1_amt3[1]+t1_amt6[1]+t1_amt9[1]+t1_amt12[1])%><br><%=Util.parseDecimal(( t1_amt1[1]+t1_amt4[1]+t1_amt7[1]+t1_amt10[1]+t1_amt2[1]+t1_amt5[1]+t1_amt8[1]+t1_amt11[1]+t1_amt3[1]+t1_amt6[1]+t1_amt9[1]+t1_amt12[1])/car_type_size2)%></td> 																															
          </tr>        
                
           <!-- 내근 -->
           	<%for (int i = 0 ; i < vt_size2 ; i++){
				Hashtable ht = (Hashtable)vts2.elementAt(i);
				
					if(String.valueOf(ht.get("GUBUN")).equals("51")){	
					
					t_amt1[4] = AddUtil.parseLong(String.valueOf(ht.get("A1_1")));
					t_amt2[4] = AddUtil.parseLong(String.valueOf(ht.get("A1_2")));
				 	t_amt3[4] = AddUtil.parseLong(String.valueOf(ht.get("A1_3")));
					t_amt4[4] = AddUtil.parseLong(String.valueOf(ht.get("A2_1")));
					t_amt5[4] = AddUtil.parseLong(String.valueOf(ht.get("A2_2")));
				         t_amt6[4] = AddUtil.parseLong(String.valueOf(ht.get("A2_3")));
					t_amt7[4] = AddUtil.parseLong(String.valueOf(ht.get("A3_1")));
					t_amt8[4] = AddUtil.parseLong(String.valueOf(ht.get("A3_2")));
					t_amt9[4] = AddUtil.parseLong(String.valueOf(ht.get("A3_3")));
				         t_amt10[4] = AddUtil.parseLong(String.valueOf(ht.get("A4_1")));
					t_amt11[4] = AddUtil.parseLong(String.valueOf(ht.get("A4_2")));
					t_amt12[4] = AddUtil.parseLong(String.valueOf(ht.get("A4_3")));
										
					
		  %>			
          <tr> 
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt1[4])%></td>
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt2[4])%></td>
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt3[4])%></td>
             <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt1[4]+t_amt2[4]+t_amt3[4])%></td>
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt4[4])%></td>
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt5[4])%></td>
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt6[4])%></td>	
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt4[4]+t_amt5[4]+t_amt6[4])%></td>		
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt7[4])%></td>
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt8[4])%></td>
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt9[4])%></td>	
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt7[4]+t_amt8[4]+t_amt9[4])%></td>	
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt10[4])%></td>
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt11[4])%></td>
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt12[4])%></td>	
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt10[4]+t_amt11[4]+t_amt12[4])%></td>																		
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt1[4]+t_amt4[4]+t_amt7[4]+t_amt10[4])%></td>
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt2[4]+t_amt5[4]+t_amt8[4]+t_amt11[4])%></td>
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt3[4]+t_amt6[4]+t_amt9[4]+t_amt12[4])%></td>	   
            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt1[4]+t_amt4[4]+t_amt7[4]+t_amt10[4]+t_amt2[4]+t_amt5[4]+t_amt8[4]+t_amt11[4]+t_amt3[4]+t_amt6[4]+t_amt9[4]+t_amt12[4])%></td> 																															
          </tr>
          <%		
          		  	t1_amt1[4] += AddUtil.parseLong(String.valueOf(ht.get("A1_1")));
					t1_amt2[4] += AddUtil.parseLong(String.valueOf(ht.get("A1_2")));
				 	t1_amt3[4] += AddUtil.parseLong(String.valueOf(ht.get("A1_3")));
					t1_amt4[4] += AddUtil.parseLong(String.valueOf(ht.get("A2_1")));
					t1_amt5[4] += AddUtil.parseLong(String.valueOf(ht.get("A2_2")));
				    t1_amt6[4] += AddUtil.parseLong(String.valueOf(ht.get("A2_3")));
					t1_amt7[4] += AddUtil.parseLong(String.valueOf(ht.get("A3_1")));
					t1_amt8[4] += AddUtil.parseLong(String.valueOf(ht.get("A3_2")));
					t1_amt9[4] += AddUtil.parseLong(String.valueOf(ht.get("A3_3")));
				    t1_amt10[4] += AddUtil.parseLong(String.valueOf(ht.get("A4_1")));
					t1_amt11[4] += AddUtil.parseLong(String.valueOf(ht.get("A4_2")));
					t1_amt12[4] += AddUtil.parseLong(String.valueOf(ht.get("A4_3")));			
					
			} } %>
          <tr> 
            <td class=title style='text-align:right; height=44;' width="5%"><%=Util.parseDecimal(t1_amt1[4])%><br><%=Util.parseDecimal(t1_amt1[4]/car_type_size5)%></td>
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt2[4])%><br><%=Util.parseDecimal(t1_amt2[4]/car_type_size5)%></td>
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt3[4])%><br><%=Util.parseDecimal(t1_amt3[4]/car_type_size5)%></td>
             <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt1[4]+t1_amt2[4]+t1_amt3[4])%><br><%=Util.parseDecimal(( t1_amt1[4]+t1_amt2[4]+t1_amt3[4])/car_type_size5)%></td>
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt4[4])%><br><%=Util.parseDecimal(t1_amt4[4]/car_type_size5)%></td>
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt5[4])%><br><%=Util.parseDecimal(t1_amt5[4]/car_type_size5)%></td>
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt6[4])%><br><%=Util.parseDecimal(t1_amt6[4]/car_type_size5)%></td>
             <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt4[4]+t1_amt5[4]+t1_amt6[4])%><br><%=Util.parseDecimal(( t1_amt4[4]+t1_amt5[4]+t1_amt6[4])/car_type_size5)%></td>			
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt7[4])%><br><%=Util.parseDecimal(t1_amt7[4]/car_type_size5)%></td>
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt8[4])%><br><%=Util.parseDecimal(t1_amt8[4]/car_type_size5)%></td>
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt9[4])%><br><%=Util.parseDecimal(t1_amt9[4]/car_type_size5)%></td>	
             <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt7[4]+t1_amt8[4]+t1_amt9[4])%><br><%=Util.parseDecimal(( t1_amt7[4]+t1_amt8[4]+t1_amt9[4])/car_type_size2)%></td>	
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt10[4])%><br><%=Util.parseDecimal(t1_amt10[4]/car_type_size5)%></td>
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt11[4])%><br><%=Util.parseDecimal(t1_amt11[4]/car_type_size5)%></td>
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt12[4])%><br><%=Util.parseDecimal(t1_amt12[4]/car_type_size5)%></td>	
             <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt10[4]+t1_amt11[4]+t1_amt12[4])%><br><%=Util.parseDecimal(( t1_amt10[4]+t1_amt11[4]+t1_amt12[4])/car_type_size5)%></td>																		
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt1[4]+t1_amt4[4]+t1_amt7[4]+t1_amt10[4])%><br><%=Util.parseDecimal(( t1_amt1[4]+t1_amt4[4]+t1_amt7[4]+t1_amt10[4])/car_type_size5)%></td>
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt2[4]+t1_amt5[4]+t1_amt8[4]+t1_amt11[4])%><br><%=Util.parseDecimal(( t1_amt2[4]+t1_amt5[4]+t1_amt8[4]+t1_amt11[4])/car_type_size5)%></td>
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt3[4]+t1_amt6[4]+t1_amt9[4]+t1_amt12[4])%><br><%=Util.parseDecimal(( t1_amt3[4]+t1_amt6[4]+t1_amt9[4]+t1_amt12[4])/car_type_size5)%></td>	   
            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt1[4]+t1_amt4[4]+t1_amt7[4]+t1_amt10[4]+t1_amt2[4]+t1_amt5[4]+t1_amt8[4]+t1_amt11[4]+t1_amt3[4]+t1_amt6[4]+t1_amt9[4]+t1_amt12[4])%><br><%=Util.parseDecimal(( t1_amt1[4]+t1_amt4[4]+t1_amt7[4]+t1_amt10[4]+t1_amt2[4]+t1_amt5[4]+t1_amt8[4]+t1_amt11[4]+t1_amt3[4]+t1_amt6[4]+t1_amt9[4]+t1_amt12[4])/car_type_size5)%></td> 																															
          </tr>        
            
                
          <tr> 
            <td class=title_p style='text-align:right; height:44;'><%=Util.parseDecimal(t1_amt1[0]+t1_amt1[1]+t1_amt1[2]+t1_amt1[3]+t1_amt1[4])%><br><%=Util.parseDecimal(( t1_amt1[0]+t1_amt1[1]+t1_amt1[2]+t1_amt1[3]+t1_amt1[3])/(car_type_size1+car_type_size2+car_type_size3+car_type_size4 +car_type_size5))%></td>
            <td class=title_p style="text-align:right"><%=Util.parseDecimal(t1_amt2[0]+t1_amt2[1]+t1_amt2[2]+t1_amt2[3]+t1_amt2[4])%><br><%=Util.parseDecimal(( t1_amt2[0]+t1_amt2[1]+t1_amt2[2]+t1_amt2[3]+t1_amt2[4])/(car_type_size1+car_type_size2+car_type_size3+car_type_size4+car_type_size5 ))%></td>
            <td class=title_p style="text-align:right"><%=Util.parseDecimal(t1_amt3[0]+t1_amt3[1]+t1_amt3[2]+t1_amt3[3]+t1_amt3[4])%><br><%=Util.parseDecimal(( t1_amt3[0]+t1_amt3[1]+t1_amt3[2]+t1_amt3[3]+t1_amt3[4])/(car_type_size1+car_type_size2+car_type_size3+car_type_size4+car_type_size5 ))%></td>
            <td class=title_p style="text-align:right" ><%=Util.parseDecimal(t1_amt1[0]+t1_amt1[1]+t1_amt1[2]+t1_amt1[3]+t1_amt1[4]+t1_amt2[0]+t1_amt2[1]+t1_amt2[2]+t1_amt2[3]+t1_amt2[4]+t1_amt3[0]+t1_amt3[1]+t1_amt3[2]+t1_amt3[3]+t1_amt3[4])%><br><%=Util.parseDecimal(( t1_amt1[0]+t1_amt1[1]+t1_amt1[2]+t1_amt1[3]+t1_amt1[4]+t1_amt2[0]+t1_amt2[1]+t1_amt2[2]+t1_amt2[3]+t1_amt2[4]+t1_amt3[0]+t1_amt3[1]+t1_amt3[2]+t1_amt3[3]+t1_amt3[4])/(car_type_size1+car_type_size2+car_type_size3+car_type_size4+car_type_size5 ))%></td>
            <td class=title_p style="text-align:right"><%=Util.parseDecimal(t1_amt4[0]+t1_amt4[1]+t1_amt4[2]+t1_amt4[3]+t1_amt4[4])%><br><%=Util.parseDecimal(( t1_amt4[0]+t1_amt4[1]+t1_amt4[2]+t1_amt4[3]+t1_amt4[4])/(car_type_size1+car_type_size2+car_type_size3+car_type_size4+car_type_size5 ))%></td>
            <td class=title_p style="text-align:right"><%=Util.parseDecimal(t1_amt5[0]+t1_amt5[1]+t1_amt5[2]+t1_amt5[3]+t1_amt5[4])%><br><%=Util.parseDecimal(( t1_amt5[0]+t1_amt5[1]+t1_amt5[2]+t1_amt5[3]+t1_amt5[4])/(car_type_size1+car_type_size2+car_type_size3+car_type_size4+car_type_size5 ))%></td>
            <td class=title_p style="text-align:right"><%=Util.parseDecimal(t1_amt6[0]+t1_amt6[1]+t1_amt6[2]+t1_amt6[3]+t1_amt6[4])%><br><%=Util.parseDecimal(( t1_amt6[0]+t1_amt6[1]+t1_amt6[2]+t1_amt6[3]+t1_amt6[4])/(car_type_size1+car_type_size2+car_type_size3+car_type_size4+car_type_size5 ))%></td>
            <td class=title_p style="text-align:right" ><%=Util.parseDecimal(t1_amt4[0]+t1_amt4[1]+t1_amt4[2]+t1_amt4[3]+t1_amt4[4]+t1_amt5[0]+t1_amt5[1]+t1_amt5[2]+t1_amt5[3]+t1_amt5[4]+t1_amt6[0]+t1_amt6[1]+t1_amt6[2]+t1_amt6[3]+t1_amt6[4])%><br><%=Util.parseDecimal(( t1_amt4[0]+t1_amt4[1]+t1_amt4[2]+t1_amt4[3]+t1_amt4[4]+t1_amt5[0]+t1_amt5[1]+t1_amt5[2]+t1_amt5[3]+t1_amt5[4]+t1_amt6[0]+t1_amt6[1]+t1_amt6[2]+t1_amt6[3]+t1_amt6[4])/(car_type_size1+car_type_size2+car_type_size3+car_type_size4+car_type_size5 ))%></td>
            <td class=title_p style="text-align:right"><%=Util.parseDecimal(t1_amt7[0]+t1_amt7[1]+t1_amt7[2]+t1_amt7[3]+t1_amt7[4])%><br><%=Util.parseDecimal(( t1_amt7[0]+t1_amt7[1]+t1_amt7[2]+t1_amt7[3]+t1_amt7[4])/(car_type_size1+car_type_size2+car_type_size3+car_type_size4+car_type_size5 ))%></td>
            <td class=title_p style="text-align:right"><%=Util.parseDecimal(t1_amt8[0]+t1_amt8[1]+t1_amt8[2]+t1_amt8[3]+t1_amt8[4])%><br><%=Util.parseDecimal(( t1_amt8[0]+t1_amt8[1]+t1_amt8[2]+t1_amt8[3]+t1_amt8[4])/(car_type_size1+car_type_size2+car_type_size3+car_type_size4+car_type_size5))%></td>
            <td class=title_p style="text-align:right"><%=Util.parseDecimal(t1_amt9[0]+t1_amt9[1]+t1_amt9[2]+t1_amt9[3]+t1_amt9[4])%><br><%=Util.parseDecimal(( t1_amt9[0]+t1_amt9[1]+t1_amt9[2]+t1_amt9[3]+t1_amt9[4])/(car_type_size1+car_type_size2+car_type_size3+car_type_size4+car_type_size5))%></td>
            <td class=title_p style="text-align:right" ><%=Util.parseDecimal(t1_amt7[0]+t1_amt7[1]+t1_amt7[2]+t1_amt7[3]+t1_amt7[4]+t1_amt8[0]+t1_amt8[1]+t1_amt8[2]+t1_amt8[3]+t1_amt8[4]+t1_amt9[0]+t1_amt9[1]+t1_amt9[2]+t1_amt9[3]+t1_amt9[4])%><br><%=Util.parseDecimal(( t1_amt7[0]+t1_amt7[1]+t1_amt7[2]+t1_amt7[3]+t1_amt7[4]+t1_amt8[0]+t1_amt8[1]+t1_amt8[2]+t1_amt8[3]+t1_amt8[4]+t1_amt9[0]+t1_amt9[1]+t1_amt9[2]+t1_amt9[3]+t1_amt9[4])/(car_type_size1+car_type_size2+car_type_size3+car_type_size4+car_type_size5 ))%></td>
            <td class=title_p style="text-align:right"><%=Util.parseDecimal(t1_amt10[0]+t1_amt10[1]+t1_amt10[2]+t1_amt10[3]+t1_amt10[4])%><br><%=Util.parseDecimal(( t1_amt10[0]+t1_amt10[1]+t1_amt10[2]+t1_amt10[3]+t1_amt10[4])/(car_type_size1+car_type_size2+car_type_size3+car_type_size4+car_type_size5 ))%></td>
            <td class=title_p style="text-align:right"><%=Util.parseDecimal(t1_amt11[0]+t1_amt11[1]+t1_amt11[2]+t1_amt11[3]+t1_amt11[4])%><br><%=Util.parseDecimal(( t1_amt11[0]+t1_amt11[1]+t1_amt11[2]+t1_amt11[3]+t1_amt11[4])/(car_type_size1+car_type_size2+car_type_size3+car_type_size4+car_type_size5 ))%></td>
            <td class=title_p style="text-align:right"><%=Util.parseDecimal(t1_amt12[0]+t1_amt12[1]+t1_amt12[2]+t1_amt12[3]+t1_amt12[4])%><br><%=Util.parseDecimal(( t1_amt12[0]+t1_amt12[1]+t1_amt12[2]+t1_amt12[3]+t1_amt12[4])/(car_type_size1+car_type_size2+car_type_size3+car_type_size4+car_type_size5 ))%></td>
            <td class=title_p style="text-align:right" ><%=Util.parseDecimal(t1_amt10[0]+t1_amt10[1]+t1_amt10[2]+t1_amt10[3]+t1_amt10[4]+t1_amt11[0]+t1_amt11[1]+t1_amt11[2]+t1_amt11[3]+t1_amt11[4]+t1_amt12[0]+t1_amt12[1]+t1_amt12[2]+t1_amt12[3]+t1_amt12[4])%><br><%=Util.parseDecimal(( t1_amt10[0]+t1_amt10[1]+t1_amt10[2]+t1_amt10[3]+t1_amt10[4]+t1_amt11[0]+t1_amt11[1]+t1_amt11[2]+t1_amt11[3]+t1_amt11[4]+t1_amt12[0]+t1_amt12[1]+t1_amt12[2]+t1_amt12[3]+t1_amt12[4])/(car_type_size1+car_type_size2+car_type_size3+car_type_size4+car_type_size5 ))%></td>
            <td class=title_p style="text-align:right"><%=Util.parseDecimal(t1_amt1[0]+t1_amt1[1]+t1_amt1[2]+t1_amt1[3]+t1_amt1[4]+t1_amt4[0]+t1_amt4[1]+t1_amt4[2]+t1_amt4[3]+t1_amt4[4]+t1_amt7[0]+t1_amt7[1]+t1_amt7[2]+t1_amt7[3]+t1_amt7[4]+t1_amt10[0]+t1_amt10[1]+t1_amt10[2]+t1_amt10[3]+t1_amt10[4])%><br><%=Util.parseDecimal(( t1_amt1[0]+t1_amt1[1]+t1_amt1[2]+t1_amt1[3]+t1_amt1[4]+t1_amt4[0]+t1_amt4[1]+t1_amt4[2]+t1_amt4[3]+t1_amt4[4]+t1_amt7[0]+t1_amt7[1]+t1_amt7[2]+t1_amt7[3]+t1_amt7[4]+t1_amt10[0]+t1_amt10[1]+t1_amt10[2]+t1_amt10[3]+t1_amt10[4])/(car_type_size1+car_type_size2+car_type_size3+car_type_size4+car_type_size5 ))%></td>
            <td class=title_p style="text-align:right"><%=Util.parseDecimal(t1_amt2[0]+t1_amt2[1]+t1_amt2[2]+t1_amt2[3]+t1_amt2[4]+t1_amt5[0]+t1_amt5[1]+t1_amt5[2]+t1_amt5[3]+t1_amt5[4]+t1_amt8[0]+t1_amt8[1]+t1_amt8[2]+t1_amt8[3]+t1_amt8[4]+t1_amt11[0]+t1_amt11[1]+t1_amt11[2]+t1_amt11[3]+t1_amt11[4])%><br><%=Util.parseDecimal(( t1_amt2[0]+t1_amt2[1]+t1_amt2[2]+t1_amt2[3]+t1_amt2[4]+t1_amt5[0]+t1_amt5[1]+t1_amt5[2]+t1_amt5[3]+t1_amt5[4]+t1_amt8[0]+t1_amt8[1]+t1_amt8[2]+t1_amt8[3]+t1_amt8[4]+t1_amt11[0]+t1_amt11[1]+t1_amt11[2]+t1_amt11[3]+t1_amt11[4])/(car_type_size1+car_type_size2+car_type_size3+car_type_size4+car_type_size5 ))%></td>
            <td class=title_p style="text-align:right"><%=Util.parseDecimal(t1_amt3[0]+t1_amt3[1]+t1_amt3[2]+t1_amt3[3]+t1_amt3[4]+t1_amt6[0]+t1_amt6[1]+t1_amt6[2]+t1_amt6[3]+t1_amt6[4]+t1_amt9[0]+t1_amt9[1]+t1_amt9[2]+t1_amt9[3]+t1_amt9[4]+t1_amt12[0]+t1_amt12[1]+t1_amt12[2]+t1_amt12[3]+t1_amt12[4])%><br><%=Util.parseDecimal(( t1_amt3[0]+t1_amt3[1]+t1_amt3[2]+t1_amt3[3]+t1_amt3[4]+t1_amt6[0]+t1_amt6[1]+t1_amt6[2]+t1_amt6[3]+t1_amt6[4]+t1_amt9[0]+t1_amt9[1]+t1_amt9[2]+t1_amt9[3]+t1_amt9[4]+t1_amt12[0]+t1_amt12[1]+t1_amt12[2]+t1_amt12[3]+t1_amt12[4])/(car_type_size1+car_type_size2+car_type_size3+car_type_size4+car_type_size5 ))%></td>
            <td class=title_p style="text-align:right" ><%=Util.parseDecimal(t1_amt1[0]+t1_amt1[1]+t1_amt1[2]+t1_amt1[3]+t1_amt1[4]+t1_amt4[0]+t1_amt4[1]+t1_amt4[2]+t1_amt4[3]+t1_amt4[4]+t1_amt7[0]+t1_amt7[1]+t1_amt7[2]+t1_amt7[3]+t1_amt7[4]+t1_amt10[0]+t1_amt10[1]+t1_amt10[2]+t1_amt10[3]+t1_amt10[4]+t1_amt2[0]+t1_amt2[1]+t1_amt2[2]+t1_amt2[3]+t1_amt2[4]+t1_amt5[0]+t1_amt5[1]+t1_amt5[2]+t1_amt5[3]+t1_amt5[4]+t1_amt8[0]+t1_amt8[1]+t1_amt8[2]+t1_amt8[3]+t1_amt8[4]+t1_amt11[0]+t1_amt11[1]+t1_amt11[2]+t1_amt11[3]+t1_amt11[4]+t1_amt3[0]+t1_amt3[1]+t1_amt3[2]+t1_amt3[3]+t1_amt3[4]+t1_amt6[0]+t1_amt6[1]+t1_amt6[2]+t1_amt6[3]+t1_amt6[4]+t1_amt9[0]+t1_amt9[1]+t1_amt9[2]+t1_amt9[3]+t1_amt9[4]+t1_amt12[0]+t1_amt12[1]+t1_amt12[2]+t1_amt12[3]+t1_amt12[4])%><br><%=Util.parseDecimal(( t1_amt1[0]+t1_amt1[1]+t1_amt1[2]+t1_amt1[3]+t1_amt1[4]+t1_amt4[0]+t1_amt4[1]+t1_amt4[2]+t1_amt4[3]+t1_amt4[4]+t1_amt7[0]+t1_amt7[1]+t1_amt7[2]+t1_amt7[3]+t1_amt7[4]+t1_amt10[0]+t1_amt10[1]+t1_amt10[2]+t1_amt10[3]+t1_amt10[4]+t1_amt2[0]+t1_amt2[1]+t1_amt2[2]+t1_amt2[3]+t1_amt2[4]+t1_amt5[0]+t1_amt5[1]+t1_amt5[2]+t1_amt5[3]+t1_amt5[4]+t1_amt8[0]+t1_amt8[1]+t1_amt8[2]+t1_amt8[3]+t1_amt8[4]+t1_amt11[0]+t1_amt11[1]+t1_amt11[2]+t1_amt11[3]+t1_amt11[4]+t1_amt3[0]+t1_amt3[1]+t1_amt3[2]+t1_amt3[3]+t1_amt3[4]+t1_amt6[0]+t1_amt6[1]+t1_amt6[2]+t1_amt6[3]+t1_amt6[4]+t1_amt9[0]+t1_amt9[1]+t1_amt9[2]+t1_amt9[3]+t1_amt9[4]+t1_amt12[0]+t1_amt12[1]+t1_amt12[2]+t1_amt12[3]+t1_amt12[4])/(car_type_size1+car_type_size2+car_type_size3+car_type_size4+car_type_size5 ))%></td>
          </tr>	  
        </table>
	</td>
  </tr>

  </table>
</form>
</body>
</html>
