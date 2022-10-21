<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.admin.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");

	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	
	Vector vt = ad_db.getClientDlyStat(gubun2, gubun3, s_kd, t_wd);
	int vt_size = vt.size();
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	//chrome 관련 
	String height = request.getParameter("height")==null?"":request.getParameter("height");
	
	int count =0;	
%>
<html style="overflow: hidden;">
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>

<script type="text/javascript">
$('document').ready(function() {
	//div값 화면 셋팅값으로 초기화
	var frame_height = Number($("#height").val());
	//var frame_height = Number(document.body.offsetHeight);
	
	var form_width = Number($("#form1").width());
	var title_width = Number($("#td_title").width());	
	var title_height = Number($(".left_header_table").height());
	
	$(".left_contents_div").css("height", (frame_height - title_height) -32 );	
	$(".right_contents_div").css("height", (frame_height - title_height) -32 );
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
		
		$(".left_contents_div").css("height", (frame_height - title_height) -32 ) ;	
		$(".right_contents_div").css("height", (frame_height - title_height) -32 );
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
 //-->   
</script>

<link rel=stylesheet type="text/css" href="/include/table_t.css">

</head>
<body>

<form name='form1'  id="form1" action='' method='post' target='d_content'>
<input type='hidden' name='height' id="height" value='<%=height%>'>

<table border="0" cellspacing="0" cellpadding="0" width='1910'>   
    <tr id='tr_title' style='position:relative;z-index:1'>		
        <td class='' width='490' id='td_title'> 
          <div id="left_header" class="left_header_div" style="width:490px;">		      
	   	    <table class="left_header_table" border="0" cellspacing="1" cellpadding="0" width='100%' height="60">
	               <tr> 
	                 <td width='50' class='title'>연번</td>	                 
                    <td width='120' class='title'>계약번호</td>
                    <td width='90' class='title'>계약일</td>
                    <td width="80" class='title'>차량번호</td>
                    <td width="150" class='title'>차명</td>
	               </tr>
	        </table>
        </div>
         <div id="left_contents" class="left_contents_div" style="width: 490px;" onmousewheel="fixDataOnWheel()" onScroll="dataOnScroll()">  
        <table class="left_contents_table"  border="0" cellspacing="1" cellpadding="0" width='100%'>
	     <%if(vt_size > 0){%> 
            <%	for(int i = 0 ; i < vt_size ; i++){
    				Hashtable ht = (Hashtable)vt.elementAt(i);
    				count++;
    	     %>
                <tr> 
                    <td width='50' align='center'><%=count%></td>                    		 
                    <td width='120' align='center'><%=ht.get("RENT_L_CD")%></td>
                    <td width='90' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_DT")))%></td>
                    <td width='80' align='center'><%=ht.get("CAR_NO")%></td>
                    <td width='150' align='center'><span title='<%=ht.get("CAR_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("CAR_NM")), 11)%></span></td>                    
                </tr>
         <%		}	%>
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
		       		<colgroup>
		       			<col width="60">
		       			<col width="80">
		       			<col width="90">		       			
		       			       				       					       			
		       			<col width="100">
		       			<col width="150">
		       			<col width="150">
		       			<col width="150">
		       					       			
		       			<col width="80">
		       			<col width="80">
		       			<col width="80">
		       			<col width="80">      			
		       			<col width="80">
		       			<col width="80">
		       			<col width="80">
		       			<col width="80">		       			
		       		</colgroup>
		       		<tr>
	                  <td colspan="3" class='title' >계약</td>	
	        		  <td colspan="4" class='title' >거래처</td>
	        		  <td colspan="8" class='title' >채권</td>        		  
	        	    </tr>
	        		<tr>
	        		  <td width="60" class='title'>차량구분</td>
	        		  <td width="80" class='title'>영업구분Ⅰ</td>
	        		  <td width="90" class='title'>영업구분Ⅱ</td>
	        		  		  
	        		  <td width="100" class='title'>고객구분</td>	        		  
	        	      <td width='150' class='title'>상호/성명</td>
	        	      <td width='150' class='title'>업태</td>
	        	      <td width='150' class='title'>종목</td>
	        	      
	        	      <td width='80' class='title'>총채권확보율</td>
	        	      <td width='80' class='title'>보증금</td>		        	   	        	   
	        	      <td width='80' class='title'>선납금</td>
        		      <td width='80' class='title'>개시대여료</td>
	        		  <td width='80' class='title'>보증보험</td>        		  
	        		  <td width='80' class='title'>연체회차</td>
	        		  <td width='80' class='title'>연체금액</td>
	        		  <td width='80' class='title'>영업담당자</td>
	        		</tr>
	           </table>
	       </div>
		   <div id="right_contents" class="right_contents_div" onScroll="dataOnScroll()">
		    <table class="right_contents_table" border="0" cellspacing="1" cellpadding="0" width='100%'>    
		  <%if(vt_size > 0){%>	   
    	    <%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
								
				%>
        		<tr>
        		    <td width='60' align='center'><%=ht.get("RENT_ST")%></td>
        		    <td width='80' align='center'><%=ht.get("BUS_ST")%></td>					
        		    <td width='90' align='center'><%=ht.get("PUR_BUS_ST")%></td>
        		    
        		    <td width='100' align='center'><%=ht.get("CLIENT_ST")%></td>
        		    <td width='150' align='center'><span title='<%=ht.get("FIRM_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("FIRM_NM")), 11)%></span></td>
        		    <td width='150' align='center'><span title='<%=ht.get("BUS_CDT")%>'><%=AddUtil.subData(String.valueOf(ht.get("BUS_CDT")), 11)%></span></td>
        		    <td width='150' align='center'><span title='<%=ht.get("BUS_ITM")%>'><%=AddUtil.subData(String.valueOf(ht.get("BUS_ITM")), 11)%></span></td>
        		          		    
        		    <td width='80' align='center'><%=ht.get("CREDIT_R_PER")%></td>
        		    <td width='80' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("GRT_AMT_S")))%></td>
        		    <td width='80' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("PP_AMT")))%></td>
        		    <td width='80' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("IFEE_AMT")))%></td>
        		    <td width='80' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("GI_AMT")))%></td>
        		    <td width='80' align='center'><%=ht.get("FEE_DLY_CNT")%></td>
        		    <td width='80' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("FEE_DLY_AMT")))%></td>
        		    <td width='80' align='center'><%=ht.get("USER_NM")%></td>        		  
        		    
        		</tr>
	 <%		}	%> 		
      <%} else  {%>  
		       	<tr>
			       <td colspan="15" align='center'>&nbsp;</td>
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