<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.cont.*, acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?	"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?	"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?	"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?	"":request.getParameter("end_dt");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	//chrome 관련 
	String height = request.getParameter("height")==null?"":request.getParameter("height");
	
	int count =0;
	
	Vector vt = new Vector();
	
	//if(!t_wd.equals("")){
		vt = a_db.getContCashBackFeeList(s_kd, t_wd, andor, gubun1, gubun2, gubun3);
	//}
	int cont_size = vt.size();
	
	long total_amt1 	= 0;
	long total_amt2 	= 0;
	long total_amt3 	= 0;
	long total_amt4 	= 0;
	long total_amt5 	= 0;
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

<link rel=stylesheet type="text/css" href="/include/table_t.css">

</head>

<body>
<form name='form1'  id="form1" action='' method='post' target='d_content'>
<input type='hidden' name='height' id="height" value='<%=height%>'>

<table border="0" cellspacing="0" cellpadding="0" width='1620'>
  <tr id='tr_title' style='position:relative;z-index:1'>
       <td class='' width='480' id='td_title' >  
        <div id="left_header" class="left_header_div" style="width:490px;">		      
	   	    <table class="left_header_table" border="0" cellspacing="1" cellpadding="0" width='100%' height="60">
	               <tr> 
	              	  <td width='40' class='title'>연번</td>
	                  <td width='100' class='title'>계약번호</td>
	                  <td width='80' class='title'>계약일자</td>
	                  <td width="180" class='title'>고객</td>
	                  <td width='80' class='title'>대여개시일</td>        
	               </tr>
	           </table>
        </div>
    	<div id="left_contents" class="left_contents_div" style="width: 490px;" onmousewheel="fixDataOnWheel()" onScroll="dataOnScrollLeft()">  
          <table class="left_contents_table"  border="0" cellspacing="1" cellpadding="0" width='100%'>
    <%if(cont_size > 0){%>
      <%	for(int i = 0 ; i < cont_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				String td_color = "";
				if(String.valueOf(ht.get("USE_YN")).equals("N")) td_color = "class='is'";
    				%>
                <tr> 
	                  <td <%=td_color%> width='40' align='center'><%=i+1%></td>
	                  <td <%=td_color%> width='100' align='center'><%=ht.get("RENT_L_CD")%></td>
	                  <td <%=td_color%> width='80' align='center'>
	                      <%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_DT")))%>
	                  </td>
	                  <td <%=td_color%> width='180' align='center'><span title='<%=ht.get("FIRM_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("FIRM_NM")), 13)%></span></td>
	                  <td <%=td_color%> width='80' align='center'>
	                      <%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT")))%>
	                  </td>
                </tr>
        <%		}	%>
         		 <tr> 
                    <td class="title" align='center' colspan='5'>합계</td>
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
	              <colgroup>
		       			<col width="130">
		       			<col width="100">
		       			<col width="130">
		       			<col width="80">		       					
		       			<col width="100"> 
		       			<col width="100"> 		       			
		       			<col width="100"> 		       					       			
		       			<col width="100">
		       			<col width="100">		       			
		       			<col width="80">		       			
		       			<col width="50">
		       			<col width="70">
		       		</colgroup> 
	
	        	    <tr>
                          <td colspan="4" class='title'>자동차</td>                  
                          <td colspan="2" class='title'>차량가격</td>
		        		  <td colspan="4" class='title'>탁송썬팅비용등</td>        		  
		        		  <td rowspan="2" width='50' class='title'>최초<br>영업자</td>
		        		  <td rowspan="2" width='70' class='title'>출고<br>영업사원</td>
	        	    </tr>
	        	    <tr>
		        		  <td width="130" class='title'>제조사</td>
		        		  <td width="100" class='title'>출고영업소</td>
		        		  <td width="130" class='title'>차종</td>
		        		  <td width="80" class='title'>차량번호</td>
	        		  
	        	          <td width='100' class='title'>소비자가</td>
	        	          <td width='100' class='title'>매출D/C</td>
	
	        	          <td width='100' class='title'>예상금액</td>
	        	          <td width='100' class='title'>지급금액</td>
	        	          <td width='100' class='title'>차액</td>
	        	          <td width='80' class='title'>지급일자</td>
	        	    </tr>
	         </table>
	   	   </div>
		   <div id="right_contents" class="right_contents_div" onScroll="dataOnScroll()">
		    <table class="right_contents_table" border="0" cellspacing="1" cellpadding="0" width='100%'>  
  <%if(cont_size > 0){%>
  
        <%	for(int i = 0 ; i < cont_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				String td_color = "";
				if(String.valueOf(ht.get("USE_YN")).equals("N")) td_color = " class=is ";
				total_amt1 	= total_amt1 + AddUtil.parseLong(String.valueOf(ht.get("CAR_C_AMT")));
				total_amt2 	= total_amt2 + AddUtil.parseLong(String.valueOf(ht.get("DC_AMT")));
				total_amt3 	= total_amt3 + AddUtil.parseLong(String.valueOf(ht.get("IMPORT_BANK_AMT")));				
				total_amt4 	= total_amt4 + AddUtil.parseLong(String.valueOf(ht.get("R_IMPORT_BANK_AMT")));
				total_amt5 	= total_amt5 + AddUtil.parseLong(String.valueOf(ht.get("CHA_AMT")));
				%>
        		<tr>
        		  <td <%=td_color%> width='130' align='center'><span title='<%=ht.get("CAR_COMP_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("CAR_COMP_NM")), 12)%></span></td>
        		  <td <%=td_color%> width='100' align='center'><span title='<%=ht.get("CAR_OFF_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("CAR_OFF_NM")), 7)%></span></td>
        		  <td <%=td_color%> width='130' align='center'><span title='<%=ht.get("CAR_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("CAR_NM")), 10)%></span></td>
        		  <td <%=td_color%> width='80' align='center'><%=ht.get("CAR_NO")%></td>					
        		  <td <%=td_color%> width='100' align='right'><%=Util.parseDecimal(String.valueOf(ht.get("CAR_C_AMT")))%></td>
        		  <td <%=td_color%> width='100' align='right'><%=Util.parseDecimal(String.valueOf(ht.get("DC_AMT")))%></td>
        		  <td <%=td_color%> width='100' align='right'><%=Util.parseDecimal(String.valueOf(ht.get("IMPORT_BANK_AMT")))%></td>
        		  <td <%=td_color%> width='100' align='right'><%=Util.parseDecimal(String.valueOf(ht.get("R_IMPORT_BANK_AMT")))%></td>
        		  <td <%=td_color%> width='100' align='right'><%=Util.parseDecimal(String.valueOf(ht.get("CHA_AMT")))%></td>
        		  <td <%=td_color%> width='80' align='center'>
        		      <%if(!String.valueOf(ht.get("IM_BANK_PAY_DT")).equals("")){%>
        		          <a href="javascript:parent.reg_pay_dt('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>');"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("IM_BANK_PAY_DT")))%></a>
        		      <%}else{%>
        		          <a href="javascript:parent.reg_pay_dt('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>');" class="btn"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a>
        		      <%}%>
        		  </td>
        		  <td <%=td_color%> width='50' align='center'><%=ht.get("USER_NM")%></td>
        		  <td <%=td_color%> width='70' align='center'><span title='<%=ht.get("EMP_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("EMP_NM")), 4)%></span></td>
        		</tr>
		<%		}	%>
                <tr> 
                    <td class="title" colspan='4'>&nbsp;</td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt1)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt2)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt3)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt4)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt5)%></td>
                    <td class="title" colspan='3'>&nbsp;</td>
                </tr>
<%} else  {%>  
		       <tr>
			        <td width="1140" colspan="12" align='center'>&nbsp;</td>
			   </tr>	              
   <%}	%>
	          </table>
	        </div>
	    </td>
    </tr>
</table>
</form>	         

<script language='javascript'>
<!--
	parent.document.form1.size.value = '<%=cont_size%>';
//-->
</script>
</body>
</html>


