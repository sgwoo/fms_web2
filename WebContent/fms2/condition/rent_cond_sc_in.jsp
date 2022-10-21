<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.condition.*" %>


<%
	ConditionDatabase cdb = ConditionDatabase.getInstance();

	String ref_dt1 = Util.getDate();
	String ref_dt2 = Util.getDate();
	String auth_rw = "";
	String dt = "2";
	String g_fm = "1";
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	
	if(request.getParameter("auth_rw") != null)	auth_rw = request.getParameter("auth_rw");
	if(request.getParameter("dt") != null)	dt = request.getParameter("dt");
	if(request.getParameter("ref_dt1") != null)	ref_dt1 = request.getParameter("ref_dt1");
	if(request.getParameter("ref_dt2") != null)	ref_dt2 = request.getParameter("ref_dt2");
	
	Vector vt = cdb.getRentCondAll_type2(dt, ref_dt1, ref_dt2, gubun2, gubun3, gubun4, sort);
	int vt_size = vt.size();
	
	long t_amt1[] = new long[1];
    	long t_amt2[] = new long[1];
    	long t_amt3[] = new long[1];
    	long t_amt7[] = new long[1];
    	long t_amt8[] = new long[1];
    
    	float t_amt4[] = new float[1];
    	float t_amt5[] = new float[1];
    	float t_per[] = new float[1];
    	float t_per2 = 0;
    	
    	int t_cnt1 	= 0;
    	int t_cnt2 	= 0;
    	int t_cnt3 	= 0;
    	
    	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
    	
    	//chrome 관련 
    	String height = request.getParameter("height")==null?"":request.getParameter("height");
    
%>

<html style="overflow: hidden;">
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script type="text/javascript">
$('document').ready(function() {
	//div값 화면 셋팅값으로 초기화
	var frame_height = Number($("#height").val());
	//var frame_height = Number(document.body.offsetHeight);
	
	var form_width = Number($("#form1").width());
	var title_width = Number($("#td_title").width());	
	var title_height = Number($(".left_header_table").height());
	
	$(".left_contents_div").css("height", (frame_height - title_height) -50 );	
	$(".right_contents_div").css("height", (frame_height - title_height) -50  );
	/* $(".left_contents_div").css("height", frame_height - 100);	
	$(".right_contents_div").css("height", frame_height - 100); */
	
	$(".right_header_div").css("width", form_width - title_width);
	$(".right_contents_div").css("width", form_width - title_width);
		
	//브라우저 리사이즈시 width, height값 조정
	$(window).resize(function (){
		
		var frame_height = Number($("#height").val());
		//var frame_height = Number(document.body.offsetHeight);
		
		var form_width = Number($("#form1").width());
		var title_width = Number($("#td_title").width());		
		var title_height = Number($(".left_header_table").height());
		
		$(".left_contents_div").css("height", (frame_height - title_height) - 50) ;	
		$(".right_contents_div").css("height", (frame_height - title_height) -50 );
		/* $(".left_contents_div").css("height", frame_height - 100);	
		$(".right_contents_div").css("height", frame_height - 100); */
		
		$(".right_header_div").css("width", form_width - title_width);
		$(".right_contents_div").css("width", form_width - title_width);		
	})

});
</script>
<script language='javascript'>
<!--
	
		//레이아웃 스크롤 제어
	function fixDataOnWheel(){
        if(event.wheelDelta < 0){
            DataScroll.doScroll('scrollbarDown');
        }else{
            DataScroll.doScroll('scrollbarUp');
        }d
        dataOnScroll();
    }
	
	function dataOnScroll() {
        left_contents.scrollTop = right_contents.scrollTop;
        right_header.scrollLeft = right_contents.scrollLeft;
    }
	
	function dataOnScrollLeft() {
        right_contents.scrollTop = left_contents.scrollTop;     
    }

	
 //-->   
</script>

</head>

<body>
<form name='form1'  id="form1" action='' method='post' target='d_content'>
<input type='hidden' name='height' id="height" value='<%=height%>'>

<table border=0 cellspacing=0 cellpadding=0 width="2140">
 <tr id='tr_title' style='position:relative;z-index:1'>
     <td class='' width='230' id='td_title' >  
        <div id="left_header" class="left_header_div" style="width:240px;">		      
	   	    <table class="left_header_table" border="0" cellspacing="1" cellpadding="0" width='100%' height="60">
	               <tr> 
	          		   <td width=40 class=title style='height:36'>연<br>번</td>
                       <td width=110 class=title>계약번호</td>
                       <td width=80 class=title style='height:36'>계약일</td> 
	               </tr>
	           </table>
        </div>
      	<div id="left_contents" class="left_contents_div" style="width: 240px;" onmousewheel="fixDataOnWheel()" onScroll="dataOnScrollLeft()">  
        <table class="left_contents_table"  border="0" cellspacing="1" cellpadding="0" width='100%'>
	    <%	if(vt_size > 0){ %>
	         <% for (int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);%>
                    <tr> 
                        <td align="center" width=40><%= i+1%></td>
                        <td align="center" width=110><%=ht.get("RENT_L_CD")%></td>
                        <td width=80 align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_DT")))%></td>
                    </tr>
              <%}%>
       			   	<tr> 
			                  <td  class='title' colspan='3'>&nbsp;합계</td>
			        </tr>
				 <%} else  {%>  
			       	<tr>
           				<td align='center'>등록된 데이타가 없습니다</td>
			        </tr>	              
			 <%}	%>
	         </table>
	      </div>
	 </td>	   
      <td>			
		     <div id="right_header" class="right_header_div custom_scroll">
	            <table class="right_header_table" border="0" cellspacing="1" cellpadding="0" width='100%' height="60">   
		       		       		       		       				       		
	       			<tr> 
				    		 <td width=80 class=title>대여개시일</td>
                             <td width=80 class=title>최초차량<br>등록일</td>
                             <td width=120 class=title>상호</td>
                             <td width=150 class=title>차종</td>
                          	<td width=30 class=title>계약<br>기간</td>
                             <td width=50 class=title>차량<br>구분</td>
                             <td width=50 class=title>계약<br>구분</td>
                             <td width=30 class=title>용도<br>구분</td>
                             <td width=50 class=title>관리<br>구분</td>
                             <td width=60 class=title>인수반납<br>유형</td>
                          	<td width=100 class=title>대여료산정<br>기준가격</td>
                          	<td width=100 class=title>선수금</td>
                          	<td width=50 class=title>선수율</td>
                          	<td width=100 class=title>대여료</td>
                          	<td width=50 class=title>DC율</td>
                          	<td width=100 class=title>총대여료</td>
                          	<td width=100 class=title>매입옵션</td>
                          	<td width=100 class=title>표준약정<br>운행거리</td>
                          	<td width=100 class=title>계약약정<br>운행거리</td>
                          	<td width=100 class=title>약정운행거리<br>차이</td>
                          	<td width=60 class=title>최초<br>영업자</td>
                          	<td width=50 class=title>실적<br>이관</td>
                          	<td width=50 class=title>블랙<br>박스</td>
                          	<td width=50 class=title>전면<br>썬팅</td>
                          	<td width=50 class=title>내비<br>게이션</td>						
                          	<td width=50 class=title>차종<br>코드</td>
						</tr>					
                   
	           </table>
	       </div>                                    
   		   <div id="right_contents" class="right_contents_div" onScroll="dataOnScroll()">
		    <table class="right_contents_table" border="0" cellspacing="1" cellpadding="0" width='100%'>           	
<%	if(vt_size > 0){ %>
         
              <% for (int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i); 
					
					//선수금 Long			 	
			 		t_amt2[0] += AddUtil.parseLong(String.valueOf(ht.get("GRT_AMT_S"))) + AddUtil.parseLong(String.valueOf(ht.get("PP_AMT"))) + AddUtil.parseLong(String.valueOf(ht.get("IFEE_AMT")));
			 		//대여료
			 		t_amt7[0] += AddUtil.parseLong(String.valueOf(ht.get("FEE_AMT")));
			 		//총대여료
			 		t_amt3[0] += AddUtil.parseLong(String.valueOf(ht.get("FEE_AMT")))* AddUtil.parseLong(String.valueOf(ht.get("CON_MON")));
					//선수금 Float 					
					t_amt4[0] =  AddUtil.parseFloat(String.valueOf(ht.get("GRT_AMT_S"))) + AddUtil.parseFloat(String.valueOf(ht.get("PP_AMT"))) + AddUtil.parseFloat(String.valueOf(ht.get("IFEE_AMT"))); 
					//매입옵션
			 		t_amt8[0] += AddUtil.parseLong(String.valueOf(ht.get("OPT_AMT")));
					
					
					if ( ht.get("EXT_ST").equals("연장")) {
						//대여료산정기준가격 -차가 Float
						t_amt5[0] =  AddUtil.parseFloat(String.valueOf(ht.get("SH_AMT"))); 
						//대여료산정기준가격 -차가 Long
						t_amt1[0] += AddUtil.parseLong(String.valueOf(ht.get("SH_AMT")));
					} else { 
					    if ( ht.get("CAR_GU").equals("재리스")) {
							t_amt5[0] =  AddUtil.parseFloat(String.valueOf(ht.get("SH_AMT"))); 
							t_amt1[0] += AddUtil.parseLong(String.valueOf(ht.get("SH_AMT")));
						} else {
							t_amt5[0] =  AddUtil.parseFloat(String.valueOf(ht.get("CAR_AMT"))); 
							t_amt1[0] += AddUtil.parseLong(String.valueOf(ht.get("CAR_AMT")));
						}
					}
					
					t_per[0] =  t_amt4[0]/t_amt5[0]* 100;
					
					if(String.valueOf(ht.get("TINT_B_YN")).equals("Y"))	t_cnt1++;
					if(String.valueOf(ht.get("TINT_S_YN")).equals("Y"))	t_cnt2++;
					if(String.valueOf(ht.get("TINT_N_YN")).equals("Y"))	t_cnt3++;
					
					t_per2 = t_per2 + AddUtil.parseFloat(String.valueOf(ht.get("DC_RA")));
					
			%>
                            <tr>                                
                                <td width=80 align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT")))%></td>
                                <td width=80 align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("INIT_REG_DT")))%></td>
                                <td width=120 align="left">&nbsp;<span title="<%=ht.get("FIRM_NM")%>"><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 8)%></a></span></td>                            
                                <td width=150 align="left"><span title="<%= ht.get("CAR_NM")+" "+ht.get("CAR_NAME") %>">&nbsp;<%= Util.subData(String.valueOf(ht.get("CAR_NM"))+" "+String.valueOf(ht.get("CAR_NAME")),12) %></span></td>                            
                                <td width=30 align="center"><%=ht.get("CON_MON")%></td>
                                <td width=50 align="center"><%=ht.get("CAR_GU")%></td>								
                                <td width=50 align="center"><%=ht.get("RENT_ST")%></td>								
                                <td width=30 align="center"><%=ht.get("CAR_ST")%></td>								
                                <td width=50 align="center"><%=ht.get("RENT_WAY")%></td>		                                
                                <td width=60 align="center"><%=ht.get("RETURN_SELECT")%></td>								
                                <td width=100 align="right"><%=Util.parseDecimal(t_amt5[0])%></td>	
                                <td width=100 align="right"><%=Util.parseDecimal(t_amt4[0])%></td>	
                                <td width=50 align="right"><%=AddUtil.parseFloatCipher2(t_per[0],1)%></td>	
                                <td width=100 align="right"><%=Util.parseDecimal(ht.get("FEE_AMT"))%></td>	
                                <td width=50 align="right"><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht.get("DC_RA"))),1)%></td>		                                
                                <td width=100 align="right"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("FEE_AMT")))* AddUtil.parseLong(String.valueOf(ht.get("CON_MON"))))%></td>	
                                <td width=100 align="right"><%=Util.parseDecimal(ht.get("OPT_AMT"))%></td>	
                                <td width=100 align="right"><%=Util.parseDecimal(ht.get("B_AGREE_DIST"))%></td>	
                                <td width=100 align="right"><%=Util.parseDecimal(ht.get("AGREE_DIST"))%></td>	
                                <td width=100 align="right"><%=Util.parseDecimal(ht.get("CHA_AGREE_DIST"))%></td>	
                                <td width=60 align="center"><%=ht.get("BUS_NM")%></td>
                                <td width=50 align="center"><%=ht.get("DIR_PUR_COMMI_YN")%></td>		                                
                                <td width=50 align="center"><%=ht.get("TINT_B_YN")%></td>
                                <td width=50 align="center"><%=ht.get("TINT_S_YN")%></td>
                                <td width=50 align="center"><%=ht.get("TINT_N_YN")%></td>               				
                                <td width=50 align="center"><%=ht.get("JG_CODE")%></td>
                            </tr>
              <%}%>
		 <%  
		 			float g_per = 0;
		 			float g_amt2 = 0;
		 			float g_amt1 = 0;
		 			
		 			g_amt2 = (float) t_amt2[0];
		 			g_amt1 = (float) t_amt1[0];
		 			g_per = g_amt2/g_amt1 * 100;
		 			
		 %>             
                            <tr> 
                	            <td class=title style="text-align:right" colspan=10>&nbsp;</td>
                	            <td class=title style="text-align:right"><%=Util.parseDecimal(t_amt1[0])%></td>
                	            <td class=title style="text-align:right"><%=Util.parseDecimal(t_amt2[0])%></td>
                	            <td class=title style="text-align:right"><%=AddUtil.parseFloatCipher2(g_per,1)%></td>
                	            <td class=title style="text-align:right"><%=Util.parseDecimal(t_amt7[0])%></td>
                	            <td class=title style="text-align:right"><%=AddUtil.parseFloatCipher2(t_per2/vt_size,1)%></td>
                	            <td class=title style="text-align:right"><%=Util.parseDecimal(t_amt3[0])%></td>
                	            <td class=title style="text-align:right"><%=Util.parseDecimal(t_amt8[0])%></td>
                	            <td class=title style="text-align:right">&nbsp;</td>
                	            <td class=title style="text-align:right">&nbsp;</td>
                	            <td class=title style="text-align:right">&nbsp;</td>
                	            <td class=title style="text-align:right">&nbsp;</td>
                	            <td class=title style="text-align:right">&nbsp;</td>
                	            <td class=title style="text-align:right"><%=t_cnt1%></td>
                	            <td class=title style="text-align:right"><%=t_cnt2%></td>
                	            <td class=title style="text-align:right"><%=t_cnt3%></td>
                	            <td class=title style="text-align:right">&nbsp;</td>
	                        </tr>	  
                        </table>
			        </td>            		            		
            	</tr>
<%} else  {%>  
		        <tr>
				          <td width="1910" colspan="24" align='center'>&nbsp;</td>
				  </tr>	              
   <%}	%>
	            </table>
	        </div>
	    </td>
    </tr>
</table>
</form>	          
</body>
</html>