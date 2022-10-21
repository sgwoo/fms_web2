<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="JsDb" scope="page" class="card.JungSanDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();

   	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
   	int i_year = request.getParameter("st_year")==null?AddUtil.getDate2(1):Integer.parseInt(request.getParameter("st_year"));	
  
	
	//chrome 관련 

	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 3; //현황 출력 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height) - 100;//현황 라인수만큼 제한 아이프레임 사이즈
	  
	
	String st_year		 = Integer.toString(i_year);
	String st_mon		= request.getParameter("st_mon")==null?"":request.getParameter("st_mon"); //분기
		
	int m_cnt =  JsDb.checkStatCarOil(st_year, st_mon); 
		
	// 조회된 기간이 마감된 기간이라면 마감에서 그렇치 않다면 실시간으로
	//2011년 4분기 - 본인 유류대 뿐만아니라 고객차, 예비차 주유 포함
	//대여료는 전체평균, 유류대는 군/지점 평균 적용	
	//201206부터 지점은 지점별 80%, 군별 20%
	
	Vector vts2 = JsDb.getJungCarOilStat(st_year, st_mon);
			
	int vt_size2 = vts2.size();			
		
	int car_type_cnt = 0;
	
	int car_type_size1 = 0;
	int car_type_size2 = 0;
	int car_type_size3 = 0;
	int car_type_size4 = 0;
	
	int ecar_type_size1 = 0;  //전기차 제외 
	int ecar_type_size2 = 0;
	int ecar_type_size3 = 0;
	int ecar_type_size4 = 0;
	
	long tot_fee_amt = 0;
	
	long oil_amt1 = 0;
	long oil_amt2 = 0;
		
	long oil_amt2_d = 0;
	long oil_amt2_b = 0;
	
	long oil_amt3 = 0;
	long oil_amt4 = 0;
	
	long oil_amt4_d = 0;
	long oil_amt4_b = 0;
	long t_oil_amt = 0;
	
	int sale_cnt1 = 0;
	int sale_cnt2 = 0;
	int sale_cnt3 = 0;
	int sale_cnt4 = 0;
	
	int sale_cnt = 0;
			
	for(int i = 0 ; i < vt_size2 ; i++){
		Hashtable ht = (Hashtable)vts2.elementAt(i);
		if(String.valueOf(ht.get("GUBUN")).equals("12")) {		
		 	car_type_size1++;		 
		 	sale_cnt1 += AddUtil.parseLong(String.valueOf(ht.get("TOT_CNT"))) ;		
		 	if ( !String.valueOf(ht.get("FUEL_KD")).equals("8")) {		
		    	ecar_type_size1++;		
		   }	 		 	
		} 
			
		if(String.valueOf(ht.get("GUBUN")).equals("32")) {
			 car_type_size2++;		
			 sale_cnt2 += AddUtil.parseLong(String.valueOf(ht.get("TOT_CNT"))) ;			
			 if ( !String.valueOf(ht.get("FUEL_KD")).equals("8")) {		
		    	ecar_type_size2++;		
		   }		 
		}
			 
		if(String.valueOf(ht.get("GUBUN")).equals("21")) {
			car_type_size3++;		
			sale_cnt3 += AddUtil.parseLong(String.valueOf(ht.get("TOT_CNT"))) ;	
			if ( !String.valueOf(ht.get("FUEL_KD")).equals("8")) {		
		    	ecar_type_size3++;		
		   }				 
		}
			
		if(String.valueOf(ht.get("GUBUN")).equals("31")) {
			car_type_size4++;		
			sale_cnt4 += AddUtil.parseLong(String.valueOf(ht.get("TOT_CNT"))) ;			
			if ( !String.valueOf(ht.get("FUEL_KD")).equals("8")) {		
		    	ecar_type_size4++;		
		   }			
		}	
		
	}
		
         long    sale_ave_cnt1 =  sale_cnt1/car_type_size1; //평균대수
         long    sale_ave_cnt2 =  sale_cnt2/car_type_size2; //평균대수
         long    sale_ave_cnt3 =  sale_cnt3/car_type_size3; //평균대수
         long    sale_ave_cnt4 =  sale_cnt4/car_type_size4; //평균대수

	for(int i = 0 ; i < vt_size2 ; i++){
		Hashtable ht = (Hashtable)vts2.elementAt(i);
	
	       //본사 2군
		if(String.valueOf(ht.get("GUBUN")).equals("12")) {				 
		 	oil_amt1 += AddUtil.parseLong(String.valueOf(ht.get("D_AMT"))) ;		 
		} 
			
		//지점 2군	
		if(String.valueOf(ht.get("GUBUN")).equals("32")) {			
		
			 t_oil_amt =  AddUtil.parseLong(String.valueOf(ht.get("D_AMT")))  ;	
										
			oil_amt2  += t_oil_amt;  //대수가중치 반영된  유류대	
				
			if(String.valueOf(ht.get("DEPT_ID")).equals("0007")){  //부산
				 	oil_amt2_b +=t_oil_amt;						 
			} else {
					oil_amt2_d  += t_oil_amt;					
			}
						
		}
			 
		//본사 1군	 
		if(String.valueOf(ht.get("GUBUN")).equals("21")) {	
			oil_amt3 += AddUtil.parseLong(String.valueOf(ht.get("D_AMT")));	
		}
			
		//지점 1군	
		if(String.valueOf(ht.get("GUBUN")).equals("31")) {		
		
				t_oil_amt =  AddUtil.parseLong(String.valueOf(ht.get("D_AMT"))) ;	
										
				oil_amt4  += t_oil_amt;  //대수가중치 반영된  유류대	
				
				if(String.valueOf(ht.get("DEPT_ID")).equals("0007")){  //부산
				 	oil_amt4_b +=t_oil_amt;						 
				} else {
					oil_amt4_d  += t_oil_amt;					
				}	
				
		}
							
		tot_fee_amt += AddUtil.parseLong(String.valueOf(ht.get("AMT")));
	}
			
	long ave_fee_amt = 0;
	if ( vt_size2 > 0 ) {
		ave_fee_amt = tot_fee_amt / ( car_type_size1 + car_type_size2 + car_type_size3 + car_type_size4 );
	}
	
	long t_amt1[] 	= new long[8];
	long t_amt2[] 	= new long[8];
	long t_amt3[] 	= new long[8];
	long t_amt4[] 	= new long[8];
	long t_amt5[] 	= new long[8];
	long t_amt6[] 	= new long[8];
		
	long t_amt7[] 	= new long[8];
	long t_amt8[] 	= new long[8];	
	long t_amt9[] 	= new long[8];
	long t_amt10[] 	= new long[8];
	long t_amt11[] 	= new long[8];
	long t_amt12[] 	= new long[8];
	
	long t_amt13[] 	= new long[8];  //예비
	long t_amt14[] 	= new long[8]; //고객
	long t_amt15[] 	= new long[8];	 //유류대 계
	long t_amt16[] 	= new long[8];	 //계약대여료
	
	
	long t_amt21[] 	= new long[8];	 //실제  본인
	long t_amt22[] 	= new long[8];	 //실제  예비
	long t_amt23[] 	= new long[8];	 //실제  고객
		
	long t_amt24[] 	= new long[8];	 // 편차 대여료
	long t_amt25[] 	= new long[8];	 //편차 유류대
	long t_amt26[] 	= new long[8];	 //편차계
	long t_amt27[] 	= new long[8];	 //가감액	
	
	long t_amt28[] 	= new long[8];	 //대수반영될 유류대
	long t_amt29[] 	= new long[8];	 //실제반영될 유류대
	
	long t_amt30[] 	= new long[8];	 //하이패스
	long t_amt31[] 	= new long[8];	 //캠페인반영
	long t_amt32[] 	= new long[8];	 //예비 - 카드 		
	long t_amt33[] 	= new long[8];	 //고객 - 카드		
			
	long t1_amt1[] 	= new long[8];
	long t1_amt2[] 	= new long[8];
	long t1_amt3[] 	= new long[8];
	long t1_amt4[] 	= new long[8];
	long t1_amt5[] 	= new long[8];
	long t1_amt6[] 	= new long[8];
	
	long t1_amt7[] 	= new long[8];
	long t1_amt8[] 	= new long[8];	
	long t1_amt9[] 	= new long[8];
	long t1_amt10[] = new long[8];
	long t1_amt11[] = new long[8];
	long t1_amt12[] = new long[8];
	
	long t1_amt13[] = new long[8];  //예비
	long t1_amt14[] = new long[8];  //고객
	long t1_amt15[] = new long[8]; //유류대 계
	long t1_amt16[] = new long[8]; //계약대여료
	
	long t1_amt21[] 	= new long[8];	 //실제  본인
	long t1_amt22[] 	= new long[8];	 //실제  예비
	long t1_amt23[] 	= new long[8];	 //실제  고객
	
	long t1_amt24[] 	= new long[8];	 // 편차 대여료
	long t1_amt25[] 	= new long[8];	 //편차 유류대
	long t1_amt26[] 	= new long[8];	 //편차계
	long t1_amt27[] 	= new long[8];	 //가감액	
	
	long t1_amt28[] 	= new long[8];	 //대수적용될 유류대
	long t1_amt29[] 	= new long[8];	 //실제반영될 유류대
	
	long et1_amt1[] 	= new long[8];	 //전기 - 경과대여료
	long et1_amt28[] 	= new long[8];	 //전기 - 대수적용될 유류대
	long et1_amt29[] 	= new long[8];	 //전기 - 실제반영될 유류대
	
	long t1_amt30[] 	= new long[8];	 //하이패스	
	long t1_amt31[] 	= new long[8];	 //캠페인반영
	long t1_amt32[] 	= new long[8];	 //예비 - 카드
	long t1_amt33[] 	= new long[8];	 //고객 - 카드
	
	long gt1_amt1 	= 0;
	long gt1_amt2 	=  0;
	long gt1_amt3 	=  0;
	long gt1_amt4 	=  0;
	long gt1_amt5 	=  0;
	long gt1_amt6 	=  0;
	
	long gt1_amt7 	=  0;
	long gt1_amt8 	=  0;	
	long gt1_amt9 	=  0;
	long gt1_amt10 =  0;
	long gt1_amt11 =  0;
	long gt1_amt12 =  0;
	
	long gt1_amt13 =  0;  //예비
	long gt1_amt14 =  0;  //고객
	long gt1_amt15 =  0; //유류대 계
	long gt1_amt16 =  0;//계약대여료
	
	long gt1_amt21 	=  0;	 //실제  본인
	long gt1_amt22 	=  0;	 //실제  예비
	long gt1_amt23 	=  0;	 //실제  고객
	
	long gt1_amt24 	=  0;	 // 편차 대여료
	long gt1_amt25 	=  0;	 //편차 유류대
	long gt1_amt26 	=  0; //편차계
	long gt1_amt27 	=  0;	 //가감액	
	
	long gt1_amt28 	=  0;	 //대수적용될 유류대
	long gt1_amt29 	=  0;	 //실제반영될 유류대
	
	long g_et1_amt1 	=  0;	 //전기 - 대수적용될 유류대
	long g_et1_amt28 	=  0;	 //전기 - 대수적용될 유류대
	long g_et1_amt29 	=  0;	 //전기 - 실제반영될 유류대
	
	long gt1_amt30 	=  0;	 //하이패스	
	long gt1_amt31 	=  0;	 //캠페인반영
	long gt1_amt32 	=  0;	 //예비 - 카드
	long gt1_amt33 	=  0;	 //고객 - 카드
			
	long oil_ave_amt = 0;
	long sale_ave_cnt = 0;
	
	int row1 =0;
	int wrow1 = 0;
	String gubun1 = "";
	String gubun1_nm = "";
	
	
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>

<script type="text/javascript">
$('document').ready(function() {
	//div값 화면 셋팅값으로 초기화
	var frame_height = Number($("#height").val());
	//var frame_height = Number(document.body.offsetHeight);
	
	var form_width = Number($("#form1").width());
	var title_width = Number($("#td_title").width());	
	var title_height = Number($(".left_header_table").height());
	
	$(".left_contents_div").css("height", (frame_height - title_height)  );	
	$(".right_contents_div").css("height", (frame_height - title_height)  );
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
		
				
		$(".left_contents_div").css("height", (frame_height - title_height) ) ;	
		$(".right_contents_div").css("height", (frame_height - title_height) ); 
	/*	$(".left_contents_div").css("height", frame_height - 100);	
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
	
	//저장
	function jung_save(){
	
		var fm = document.form1;
						
		fm.target='i_no';
	  	fm.action='mng_car_oil_a.jsp';		
		fm.submit();				
	}
	
		//캠페인 반영분 선택 - st_year  : 정산할 유류대 , 
	function jung_popup(){
	
		var fm = document.form1;
					
		var SUBWIN="mng_car_oil_popup.jsp?o_year=<%=st_year%>&o_mon=<%=st_mon%>";
			
		window.open(SUBWIN, "set_end", "left=50, top=50, width=400, height=300, scrollbars=yes, status=yes");
		
	}		
	
		//조회하기
	function oil_gong(o_year, o_mon, bus_id){
		var fm = document.form1;
		var SUBWIN="oil_gong_list.jsp?o_year=<%=st_year%>&o_mon=<%=st_mon%>&bus_id="+bus_id;
		
		window.open(SUBWIN, "oil_gong", "left=350, top=250, width=550, height=400, resizable=yes, scrollbars=yes, status=yes");		
	}
				
//-->
</script>
</head>
<body onLoad="javascript:init()">
<form  name="form1"  id="form1"  method="POST">
<input type='hidden' name='gubun3' 	value=''>       
<input type='hidden' name='gubun4' 	value=''> 
<input type='hidden' name='st_year' 	value='<%=st_year%>'>       
<input type='hidden' name='st_mon' 	value='<%=st_mon%>'>

<input type='hidden' name='height' id="height" value='<%=height%>'>
					  
<table border="0" cellspacing="0" cellpadding="0" width="1660">
<tr id='tr_title' style='position:relative;z-index=1'>
      <td class='' width='120' id='td_title' >  
       <div id="left_header" class="left_header_div" style="width:120px;">		      
   	    <table class="left_header_table" border="0" cellspacing="1" cellpadding="0" width='100%' style="height: 106px;">
               <tr>  
               	  <td width='50%' class='title' style='height:90'>구분</td>						
			  	  <td width='50%' class='title'>성명</td>			 
               </tr>
        </table>
       </div>
       <div id="left_contents" class="left_contents_div" style="width: 120px;" onmousewheel="fixDataOnWheel()" onScroll="dataOnScrollLeft()">  
         <table class="left_contents_table"  border="0" cellspacing="1" cellpadding="0" width='100%'> 
        
		   <% for(int k = 0 ; k < 4 ; k++){ %>				
	        <%	   
	        	  car_type_cnt =  0;
	        	  if ( k == 0 )  { 	          
		          	row1=car_type_size3; 	        
		          	gubun1 = "21";  //3
		        	gubun1_nm = "수도권 1군";  //3
		          }else if ( k== 1) {	         
		          	row1=car_type_size4; 	        
		        	gubun1 = "31";   //4
		        	gubun1_nm = "지점 1군";  //3
		          } else if ( k== 2) {	          
		          	row1=car_type_size1;
		           	gubun1 = "12";	  //1
		           	gubun1_nm = "수도권 2군";  //3
		          } else if ( k== 3) {
		        	row1=car_type_size2; 		     
			        gubun1 = "32";	  //2
			        gubun1_nm = "지점 2군";  //3
		          }    
	         	        
	        	for(int i = 0 ; i < vt_size2 ; i++){        		
	        		
	        		Hashtable ht = (Hashtable)vts2.elementAt(i);      		 		
	        	    			
	        		if(String.valueOf(ht.get("GUBUN")).equals(gubun1)){           		        		 													
				%>	
					
	          <tr> 
	            <% if(car_type_cnt==0) {  %>
	             <td align="center" width='50%' rowspan='<%=row1%>'><%=gubun1_nm%></td>
	            <%} %> 
			    <%//		if(String.valueOf(ht.get("USER_ID")).equals(ck_acar_id) || nm_db.getWorkAuthUser("총무팀남",ck_acar_id) || nm_db.getWorkAuthUser("회계업무",ck_acar_id) || nm_db.getWorkAuthUser("임원",ck_acar_id) || nm_db.getWorkAuthUser("전산팀",ck_acar_id)){%>
	            <td align="center" width="50%" height="20"><a href="javascript:list_move('11','<%=ht.get("USER_ID")%>');"><%=ht.get("USER_NM")%></a></td>
	            <%//		}else{ %>
	            <!-- <td align="center" width="50%" height="20"><%=ht.get("USER_NM")%></td> -->
	            <%//		} %>          
	          </tr>
	           <%	car_type_cnt++;}} %>	
	          <tr> 
	            <td class="title" align="center"  colspan=2  style='height:66;'>소합계<br>평균<br>평균(전기차제외) </td>            
	          </tr>
	     <% } %>  
	          <tr> 
	            <td class="title_p" align="center"  colspan=2  style='height:66;'>총합계<br>평균<br>평균(전기차제외)</td>
	          
	          </tr>                   
	        </table>
	        
	     </div>            
	</td>   <!-- left -->       
    
    <td>			
	    <div id="right_header" class="right_header_div custom_scroll" >	
	           <table class="right_header_table" border="0" cellspacing="1" cellpadding="0" width='1540' style="height: 60px;">  
	           
	             <colgroup>	 
	             		<col width='4%' >
			            <col width='7%' >
			            <col width='5%' >
			            <col width='5%' >
			            <col width='5%' >
			            <col width='5%' >          
			            <col width='3%' >           
			            <col width='5%' >
			            <col width='4%' >
			            <col width='5%' > 
			            <col width='4%' > 
			            <col width='5%' > 
			            <col width='5%' > 
			            <col width='5%' >   
			            <col width='5%' >  <!--대수반영한 유류대 -->   
			            <col width='5%' >  <!--실제적용 유류대 --> 			             
			            <col width='5%' >
			            <col width='5%' > 
			            <col width='5%' >  
			            <col width='5%' > 
			            <col width='3%' >
			       	
		       		</colgroup>  
		       		
		       		<tr>
			            <td  colspan="16"  class='title'>교통비</td>
			            <td  colspan="5"  class='title'>정산</td>  
			         </tr>
			          <tr>
			            <td  colspan="6"  class='title' >대여료</td>
			             <td colspan="10"  class='title' >유류비</td> 
			            <td  colspan="3"  class='title' >편차금액</td>  
			            <td  rowspan="4"  class='title'  width='5%'>가감금액</td>  
			           <td  rowspan="4"  class='title'  width='3%'>반영</td>  		           
			         </tr>
		          	        
			          <tr>
			            <td width='4%' class='title' rowspan=2 >차량번호</td>
			            <td width='7%' class='title'  rowspan=2 >차명</td>
			            <td width='5%' class='title'  rowspan=2 >정상대여료</td>  <!--1분기 -->
			            <td width='5%' class='title'  rowspan=2 >계약대여료</td>  <!--1분기 -->
			            <td width='5%' class='title'  rowspan=2 >반영대여료</td>  <!--1분기 -->
			            <td width='5%' class='title'  rowspan=2 >경과대여료</td>  <!--1분기 -->          
			            <td width='3%' class='title'  rowspan=2 >대수</td>           
			            <td width='5%' class='title' rowspan=2 >본인</td>
			            <td  class='title' colspan=2>예비</td>
			            <td  class='title' colspan=2>고객</td> 
			            <td width='5%' class='title' rowspan=2 >여비<br>교통비</td> 
			            <td width='5%' class='title' rowspan=2>계</td>  <!--유류대 소계 -->   
			            <td width='5%' class='title' rowspan=2>대수적용</td>  <!--대수반영한 유류대 -->   
			            <td width='5%' class='title' rowspan=2>적용값</td>  <!--실제적용 유류대 -->   
			             
			            <td width='5%' class='title' rowspan=2>대여료</td>
			            <td width='5%' class='title' rowspan=2>유류비</td> 
			            <td width='5%' class='title' rowspan=2>계</td>  <!--유류대 소계 -->   
			         </tr>
			          <tr>
			            <td width='4%' class='title'>카드</td>
			            <td width='5%' class='title'>그외</td> 
			            <td width='4%' class='title'>카드</td> 
			            <td width='5%' class='title'>그외</td> 		             
			         </tr>
	    	    </table>
	     </div>      
		<div id="right_contents" class="right_contents_div" onScroll="dataOnScroll()">
			    <table class="right_contents_table" border="0" cellspacing="1" cellpadding="0" width='1540'>  	      
		
				 <!--편차평균을 구하기 위해서 한번더 계산 -->    
				<% 	oil_ave_amt = 0;
			        oil_ave_amt = oil_amt3/car_type_size3;    
			        
			        for(int k = 0 ; k < 4 ; k++){ %>				
			        <%	   
			        	  car_type_cnt =  0;
			        	  if ( k == 0 )  { 	          
				          	row1=car_type_size3; 	   
				          	wrow1=ecar_type_size3;
				          	gubun1 = "21";  //3
				        	gubun1_nm = "수도권 1군";  //3
				        	sale_ave_cnt = sale_ave_cnt3;
				        	sale_cnt = sale_cnt3;
				          }else if ( k== 1) {	         
				          	row1=car_type_size4; 	 
				          	wrow1=ecar_type_size4;
				        	gubun1 = "31";   //4
				        	gubun1_nm = "지점 1군";  //3
				        	sale_ave_cnt = sale_ave_cnt4;
				        	sale_cnt = sale_cnt4;
				          } else if ( k== 2) {	          
				          	row1=car_type_size1;
				          	wrow1=ecar_type_size1;
				           	gubun1 = "12";	  //1
				           	gubun1_nm = "수도권 2군";  //3
				           	sale_ave_cnt = sale_ave_cnt1;
				           	sale_cnt = sale_cnt1;
				          } else if ( k== 3) {
				        	row1=car_type_size2; 
				        	wrow1=ecar_type_size2;
				            gubun1 = "32";	  //2
					        gubun1_nm = "지점 2군";  //3
					    	sale_ave_cnt = sale_ave_cnt2;
					    	sale_cnt = sale_cnt2;
				          }    
			         	        
			        	for(int i = 0 ; i < vt_size2 ; i++){      
			        		       
							Hashtable ht = (Hashtable)vts2.elementAt(i);
							
								if(String.valueOf(ht.get("GUBUN")).equals(gubun1)){	
								
								t_amt5[k] = AddUtil.parseLong(String.valueOf(ht.get("AMT")));
								
								t_amt1[k] = AddUtil.parseLong(String.valueOf(ht.get("AMT")));				
								t_amt4[k] = AddUtil.parseLong(String.valueOf(ht.get("FEE_S_AMT")));	
								t_amt16[k] = AddUtil.parseLong(String.valueOf(ht.get("CONT_S_AMT")));	
								
								t_amt21[k] = AddUtil.parseLong(String.valueOf(ht.get("OIL_AMT")));	 
								t_amt22[k] = AddUtil.parseLong(String.valueOf(ht.get("OIL_1_AMT")));	 
								t_amt23[k] = AddUtil.parseLong(String.valueOf(ht.get("OIL_2_AMT")));	 
								
								t_amt30[k] = AddUtil.parseLong(String.valueOf(ht.get("HI_AMT")));	 
								t_amt32[k] = AddUtil.parseLong(String.valueOf(ht.get("OIL_C_1_AMT")));	 //예비 - 카드
								t_amt33[k] = AddUtil.parseLong(String.valueOf(ht.get("OIL_C_2_AMT")));	 //고객  - 카드
																	
								t_amt28[k] =AddUtil.parseLong(String.valueOf(ht.get("D_AMT"))) ;	  //대수가중치 반영된  유류대
								t_amt29[k] =AddUtil.parseLong(String.valueOf(ht.get("J_AMT"))) ;	  //실적용 가중치 반영된  유류대
								
								t_amt24[k] =AddUtil.parseLong(String.valueOf(ht.get("CAL_1_AMT"))) ;	    //대여료계    		
								t_amt25[k] =AddUtil.parseLong(String.valueOf(ht.get("CAL_2_AMT"))) ;	      //유류대계    	
								
								t_amt26[k] = AddUtil.parseLong(String.valueOf(ht.get("CAL_AMT")));  //편차금액	 
								t_amt27[k] = AddUtil.parseLong(String.valueOf(ht.get("JUNG_AMT")));  //가감금액	 
								
								t_amt31[k] = AddUtil.parseLong(String.valueOf(ht.get("GONG_AMT")));  //가감금액	 	
																				
								t1_amt28[k] += AddUtil.parseLong(String.valueOf(ht.get("D_AMT"))) ;	  //대수가중치 반영된  유류대
								t1_amt29[k] +=  AddUtil.parseLong(String.valueOf(ht.get("J_AMT"))) ;	  //실적용  반영된  유류대							
															
							   if(!String.valueOf(ht.get("FUEL_KD")).equals("8"))  {	   //전기차가 아니면  							
									et1_amt28[k] += AddUtil.parseLong(String.valueOf(ht.get("D_AMT"))) ;	  //대수가중치 반영된 유류대
									et1_amt29[k] +=  AddUtil.parseLong(String.valueOf(ht.get("J_AMT"))) ;	  //실적용  반영된  유류대										
								}							
															
								t1_amt24[k] +=AddUtil.parseLong(String.valueOf(ht.get("CAL_1_AMT"))) ;	     //대여료계    		
								t1_amt25[k] +=AddUtil.parseLong(String.valueOf(ht.get("CAL_2_AMT"))) ;	     //유류대계    
								
								t1_amt26[k] += AddUtil.parseLong(String.valueOf(ht.get("CAL_AMT"))) ;;       //편차계    					
								t1_amt27[k] += AddUtil.parseLong(String.valueOf(ht.get("JUNG_AMT"))) ;		
								
								t1_amt31[k] += AddUtil.parseLong(String.valueOf(ht.get("GONG_AMT"))) ;		//캠페인반영			
																		
								t1_amt1[k] += AddUtil.parseLong(String.valueOf(ht.get("AMT")));			//합계
								t1_amt4[k] += AddUtil.parseLong(String.valueOf(ht.get("FEE_S_AMT")));	
								t1_amt16[k] += AddUtil.parseLong(String.valueOf(ht.get("CONT_S_AMT")));	
								
								t1_amt21[k] += AddUtil.parseLong(String.valueOf(ht.get("OIL_AMT")));	 
								t1_amt22[k] += AddUtil.parseLong(String.valueOf(ht.get("OIL_1_AMT")));	 
								t1_amt23[k] += AddUtil.parseLong(String.valueOf(ht.get("OIL_2_AMT")));	 	
								
								t1_amt30[k] += AddUtil.parseLong(String.valueOf(ht.get("HI_AMT")));	 
								t1_amt32[k] += AddUtil.parseLong(String.valueOf(ht.get("OIL_C_1_AMT")));	 
								t1_amt33[k] += AddUtil.parseLong(String.valueOf(ht.get("OIL_C_2_AMT")));	 	
								
							
								if(!String.valueOf(ht.get("FUEL_KD")).equals("8"))  {	   //전기차가 아니면  		
									et1_amt1[k] += AddUtil.parseLong(String.valueOf(ht.get("AMT")));			
								}
								
								gt1_amt28 += AddUtil.parseLong(String.valueOf(ht.get("D_AMT"))) ;	  //대수가중치 반영된  유류대
								gt1_amt29 +=  AddUtil.parseLong(String.valueOf(ht.get("J_AMT"))) ;	  //실적용  반영된  유류대							
															
							   if(!String.valueOf(ht.get("FUEL_KD")).equals("8"))  {	   //전기차가 아니면  							
									g_et1_amt28 += AddUtil.parseLong(String.valueOf(ht.get("D_AMT"))) ;	  //대수가중치 반영된 유류대
									g_et1_amt29 +=  AddUtil.parseLong(String.valueOf(ht.get("J_AMT"))) ;	  //실적용  반영된  유류대										
								}							
															
								gt1_amt24 +=AddUtil.parseLong(String.valueOf(ht.get("CAL_1_AMT"))) ;	     //대여료계    		
								gt1_amt25 +=AddUtil.parseLong(String.valueOf(ht.get("CAL_2_AMT"))) ;	     //유류대계    
								
								gt1_amt26 += AddUtil.parseLong(String.valueOf(ht.get("CAL_AMT"))) ;;       //편차계    					
								gt1_amt27 += AddUtil.parseLong(String.valueOf(ht.get("JUNG_AMT"))) ;		
								
								gt1_amt31 += AddUtil.parseLong(String.valueOf(ht.get("GONG_AMT"))) ;		//캠페인반영			
																		
								gt1_amt1 += AddUtil.parseLong(String.valueOf(ht.get("AMT")));			//합계
								gt1_amt4 += AddUtil.parseLong(String.valueOf(ht.get("FEE_S_AMT")));	
								gt1_amt16 += AddUtil.parseLong(String.valueOf(ht.get("CONT_S_AMT")));	
								
								gt1_amt21 += AddUtil.parseLong(String.valueOf(ht.get("OIL_AMT")));	 
								gt1_amt22 += AddUtil.parseLong(String.valueOf(ht.get("OIL_1_AMT")));	 
								gt1_amt23 += AddUtil.parseLong(String.valueOf(ht.get("OIL_2_AMT")));	 	
								
								gt1_amt30 += AddUtil.parseLong(String.valueOf(ht.get("HI_AMT")));	 
								gt1_amt32 += AddUtil.parseLong(String.valueOf(ht.get("OIL_C_1_AMT")));	 
								gt1_amt33 += AddUtil.parseLong(String.valueOf(ht.get("OIL_C_2_AMT")));	 	
								
							    if(!String.valueOf(ht.get("FUEL_KD")).equals("8"))  {	   //전기차가 아니면  		
									g_et1_amt1 += AddUtil.parseLong(String.valueOf(ht.get("AMT")));			
								}
						         	
						  %>			
				          <tr>                                       
				            <td align="center" height="20" width="4%"><%=ht.get("CAR_NO")%></td>
				            <td align="center" height="20" width="7%"><%=AddUtil.subData(String.valueOf(ht.get("CAR_NM")), 7)%></td>
				            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt4[k])%></td>
				            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt16[k])%></td>
				            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt4[k]- t_amt16[k])%></td>
				            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt1[k])%></td>
				            <td align="right" height="20" width="3%"><%=AddUtil.parseLong(String.valueOf(ht.get("TOT_CNT")))%> </td>
				            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt21[k])%></td> <!--본인 -->
				            
				            <td align="right" height="20" width="4%"><%=Util.parseDecimal(t_amt32[k])%></td> <!-- 예비 - 카드 -->
				            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt22[k])%></td> <!-- 예비 - 기타 -->
				            <td align="right" height="20" width="4%"><%=Util.parseDecimal(t_amt33[k])%></td><!-- 고객  - 카드 -->
				            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt23[k])%></td> <!-- 고객 - 기타 -->            
				            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt30[k])%></td> <!-- 여비교통비 -->
				        
				            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt21[k]+t_amt22[k]+t_amt23[k]+t_amt30[k]+t_amt32[k]+t_amt33[k])%></td>            
				            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt28[k])%></td>	
				            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt29[k])%></td>	  <!-- 적용기준 -->	
				            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt24[k])%></td>      <!-- 대여료 편차 -->
				            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt25[k])%></td>      <!-- 유류비 편차 -->
				            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt26[k])%></td>      <!--  편차 계-->
				            <td align="right" height="20" width="5%"><%=Util.parseDecimal(t_amt27[k])%></td>      <!-- 가감금액 -->
				            <td align="right" height="20" width="3%">
				         
				            </td>      <!-- 정산 반영 -->  																															
				          </tr>
			        
				<%		  	 
						} }
						
					 t_amt8[k] =  t1_amt26[k] / row1; //편차평균    
					%>
			<%if(row1 >0){%>   	
				
					 <tr> 
			            <td class=title style='text-align:right; height:66;' width="4%"></td>
			            <td class=title style="text-align= center" width="7%"></td>
			            <td class=title style="text-align:right"><%=Util.parseDecimal(t1_amt4[k])%><br><%=Util.parseDecimal(t1_amt4[k]/row1)%><br>&nbsp;</td>
			            <td class=title style="text-align:right"><%=Util.parseDecimal(t1_amt16[k])%><br><%=Util.parseDecimal(t1_amt16[k]/row1)%><br>&nbsp;</td>
			            <td class=title style="text-align:right"><%=Util.parseDecimal(t1_amt4[k]- t1_amt16[k] )%><br><%=Util.parseDecimal( (t1_amt4[k] - t1_amt16[k])/row1)%><br>&nbsp;</td>            
			            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt1[k])%><br><%=Util.parseDecimal(t1_amt1[k]/row1)%><br>&nbsp;</td>
			            <td class=title style="text-align:right" width="3%"><%=Util.parseDecimal(sale_cnt)%><br><%=Util.parseDecimal(sale_ave_cnt)%><br>&nbsp;</td>
			            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt21[k])%><br><%=Util.parseDecimal(t1_amt21[k]/row1)%><br>&nbsp;</td>
			            <td class=title style="text-align:right" width="4%"><%=Util.parseDecimal(t1_amt32[k])%><br><%=Util.parseDecimal(t1_amt32[k]/row1)%><br>&nbsp;</td>  <!--예비 -->
			             <td class=title style="text-align:right"width="5%"><%=Util.parseDecimal(t1_amt22[k])%><br><%=Util.parseDecimal(t1_amt22[k]/row1)%><br>&nbsp;</td>   
			            <td class=title style="text-align:right"width="4%"><%=Util.parseDecimal(t1_amt33[k])%><br><%=Util.parseDecimal(t1_amt33[k]/row1)%><br>&nbsp;</td>
			             <td class=title style="text-align:right"width="5%"><%=Util.parseDecimal(t1_amt23[k])%><br><%=Util.parseDecimal(t1_amt23[k]/row1)%><br>&nbsp;</td>   
			            <td class=title style="text-align:right"width="5%"><%=Util.parseDecimal(t1_amt30[k])%><br><%=Util.parseDecimal(t1_amt30[k]/row1)%><br>&nbsp;</td>       
			            <td class=title style="text-align:right"width="5%"><%=Util.parseDecimal(t1_amt21[k]+t1_amt22[k]+t1_amt23[k]+t1_amt30[k]+t1_amt32[k]+t1_amt33[k])%><br><%=Util.parseDecimal((t1_amt21[k]+t1_amt22[k]+t1_amt23[k]+t1_amt30[k]+t1_amt32[k]+t1_amt33[k])/row1)%><br>&nbsp;</td>
			            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt28[k])%><br><%=Util.parseDecimal(t1_amt28[k]/row1)%><br><%=Util.parseDecimal(et1_amt28[k]/wrow1)%></td>	
			             <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt29[k])%><br><%=Util.parseDecimal(t1_amt29[k]/row1)%><br>&nbsp;</td>			
			            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt24[k])%><br><%=Util.parseDecimal(t1_amt24[k]/row1)%><br>&nbsp;</td>
			            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt25[k])%><br><%=Util.parseDecimal(t1_amt25[k]/row1)%><br>&nbsp;</td>
			            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt26[k])%><br><%=Util.parseDecimal(t_amt8[k])%><br>&nbsp;</td>
			            <td class=title style="text-align:right" width="5%"><%=Util.parseDecimal(t1_amt27[k])%><br><%=Util.parseDecimal( t1_amt27[k]/row1)%><br>&nbsp;</td> 
			              <td class=title style="text-align:right" width="5%"></td>         	    																															
			          </tr>           
					
			<% } %>   
			 <% }%>    
			 <!--  grand totol -->
			          <tr> 
			            <td class=title_p style='text-align:right; height:66;'></td>
			            <td class=title_p style="text-align:right"></td>
			            <td class=title_p style="text-align:right"><%=Util.parseDecimal(gt1_amt4)%><br><%=Util.parseDecimal(gt1_amt4/(car_type_size1+car_type_size2+car_type_size3+car_type_size4 ))%><br>&nbsp;</td>
			            <td class=title_p style="text-align:right"><%=Util.parseDecimal(gt1_amt16)%><br><%=Util.parseDecimal(gt1_amt16/(car_type_size1+car_type_size2+car_type_size3+car_type_size4 ))%><br>&nbsp;</td>
			            <td class=title_p style="text-align:right"><%=Util.parseDecimal(gt1_amt4 - gt1_amt16 )%><br><%=Util.parseDecimal(( gt1_amt4 - gt1_amt16)/(car_type_size1+car_type_size2+car_type_size3+car_type_size4 ))%><br>&nbsp;</td>
			            <td class=title_p style="text-align:right"><%=Util.parseDecimal(gt1_amt1)%><br><%=Util.parseDecimal(gt1_amt1/(car_type_size1+car_type_size2+car_type_size3+car_type_size4 ))%><br><%=Util.parseDecimal( g_et1_amt1/(ecar_type_size1+ecar_type_size2+ecar_type_size3+ecar_type_size4 ))%></td>
			            <td class=title_p style="text-align:right"><%=Util.parseDecimal(sale_cnt1+sale_cnt2+sale_cnt3+sale_cnt4)%><br><%=Util.parseDecimal(( sale_cnt1+sale_cnt2+sale_cnt3+sale_cnt4)/(car_type_size1+car_type_size2+car_type_size3+car_type_size4 ))%><br>&nbsp;</td>
			            <td class=title_p style="text-align:right"><%=Util.parseDecimal(gt1_amt21)%><br><%=Util.parseDecimal(gt1_amt21/(car_type_size1+car_type_size2+car_type_size3+car_type_size4 ))%><br>&nbsp;</td>
			             <td class=title_p style="text-align:right"><%=Util.parseDecimal(gt1_amt32)%><br><%=Util.parseDecimal(gt1_amt32/(car_type_size1+car_type_size2+car_type_size3+car_type_size4 ))%><br>&nbsp;</td>
			              <td class=title_p style="text-align:right"><%=Util.parseDecimal(gt1_amt22)%><br><%=Util.parseDecimal(gt1_amt22/(car_type_size1+car_type_size2+car_type_size3+car_type_size4 ))%><br>&nbsp;</td>        
			             <td class=title_p style="text-align:right"><%=Util.parseDecimal(gt1_amt33)%><br><%=Util.parseDecimal(gt1_amt33/(car_type_size1+car_type_size2+car_type_size3+car_type_size4 ))%><br>&nbsp;</td>
			              <td class=title_p style="text-align:right"><%=Util.parseDecimal(gt1_amt23)%><br><%=Util.parseDecimal(gt1_amt23/(car_type_size1+car_type_size2+car_type_size3+car_type_size4 ))%><br>&nbsp;</td>        
			              <td class=title_p style="text-align:right"><%=Util.parseDecimal(gt1_amt30)%><br><%=Util.parseDecimal(gt1_amt30/(car_type_size1+car_type_size2+car_type_size3+car_type_size4 ))%><br>&nbsp;</td>
			             
			             <td class=title_p style="text-align:right"><%=Util.parseDecimal(gt1_amt21+gt1_amt22+gt1_amt23+gt1_amt30+gt1_amt32+gt1_amt33)%><br><%=Util.parseDecimal(( gt1_amt21+gt1_amt22+gt1_amt23+gt1_amt30+gt1_amt32+gt1_amt33)/(car_type_size1+car_type_size2+car_type_size3+car_type_size4 ))%><br>&nbsp;</td>              
			             <td class=title_p style="text-align:right"><%=Util.parseDecimal(gt1_amt28)%><br><%=Util.parseDecimal(gt1_amt28/(car_type_size1+car_type_size2+car_type_size3+car_type_size4 ))%><br><%=Util.parseDecimal(( g_et1_amt28)/(ecar_type_size1+ecar_type_size2+ecar_type_size3+ecar_type_size4 ))%></td>
			              <td class=title_p style="text-align:right"><%=Util.parseDecimal(gt1_amt29)%><br><%=Util.parseDecimal(gt1_amt29/(car_type_size1+car_type_size2+car_type_size3+car_type_size4 ))%><br>&nbsp;</td>
			            
			              <td class=title_p style="text-align:right"><%=Util.parseDecimal(gt1_amt24)%><br><%=Util.parseDecimal(gt1_amt24/(car_type_size1+car_type_size2+car_type_size3+car_type_size4 ))%><br>&nbsp;</td>
			              <td class=title_p style="text-align:right"><%=Util.parseDecimal(gt1_amt25)%><br><%=Util.parseDecimal( gt1_amt25/(car_type_size1+car_type_size2+car_type_size3+car_type_size4 ))%><br>&nbsp;</td>
			                <td class=title_p style="text-align:right"><%=Util.parseDecimal(gt1_amt26)%><br><%=Util.parseDecimal( gt1_amt26/(car_type_size1+car_type_size2+car_type_size3+car_type_size4 ))%><br>&nbsp;</td>
			            <td class=title_p style="text-align:right"><%=Util.parseDecimal(gt1_amt27)%><br><%=Util.parseDecimal(gt1_amt27/(car_type_size1+car_type_size2+car_type_size3+car_type_size4 ))%><br>&nbsp;</td>
			            <td class=title_p style="text-align:right"></td>         	
			          </tr>	  
		      </table>
	  </div>
	 </td>
	    
    </tr>
</table>	
		 
			 
 <!-- 
<% if (user_id.equals("000063") && m_cnt < 1  ) { %>
  <a href="javascript:jung_save()"><img src=/acar/images/center/button_save.gif border=0 align=absmiddle></a><br> 
<% } %>  
<% if (user_id.equals("000063") && m_cnt > 0  ) { %>
  <a href="javascript:jung_popup()">캠페인선택반영</a><br> 
<% } %>  
-->

<font size=2>*  대여료는 전체평균 적용 </font><br>
<!--<font size=2>*  대수적용 유류대  :   본인유류대: (유류대/본인 평균대수)*군별 평균대수  ( 평균대수:관리대수+계약대수(대여개시기준))  적용 </font><br> -->
<!---<font size=2>*  대수적용 유류대  :   본인유류대: 100% 적용,   예비+고객유류대: (유류대/본인 평균대수)*군별 평균대수  ( 평균대수:관리대수+계약대수(대여개시기준))  적용 </font><br> -->
<font size=2>*  대수적용 유류대  :   본인유류대: 100% 적용 </font><br>
<font size=2>*  주차요금  :  30% 적용 </font><br>
<font size=2>*  적용기준  :  본사 -  대수적용 유류대의 평균 적용,  </font>
<font size=2>                     지점 -   (대수적용 유류대의 평균* 30 %)  + (지점별 유류대의 평균 * 70%) 적용   </font><br>
<font size=2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;     :  구분의  전기차량 이용자 비용을 제외한 평균값으로 적용<br>
<font size=2>*  가감금액 :   복지비 추가 -  (정산계 - 정산계평균) * 50% ,  캠페인 차감 -  (정산계 - 정산계평균) * 40% </font><br>

</form>

<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
