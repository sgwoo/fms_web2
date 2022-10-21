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
	
	int count =0;
	
	Vector vt = new Vector();
	
	//if(!t_wd.equals("")){
		vt = a_db.getContImAddList(s_kd, t_wd, andor, gubun1, gubun2, gubun3);
	//}
	int cont_size = vt.size();
	
	//chrome 관련 
	String height = request.getParameter("height")==null?"":request.getParameter("height");
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>

<script type="text/javascript">
$('document').ready(function() {
	//div값 화면 셋팅값으로 초기화
	var frame_height = Number($("#height").val());
	
	var form_width = Number($("#form1").width());
	var title_width = Number($("#td_title").width());	
	var title_height = Number($(".left_header_table").height());
	
	$(".left_contents_div").css("height", (frame_height - title_height) -32 );	
	$(".right_contents_div").css("height", (frame_height - title_height) -32 );
	
	$(".right_header_div").css("width", form_width - title_width);
	$(".right_contents_div").css("width", form_width - title_width);
		
	//브라우저 리사이즈시 width, height값 조정
	$(window).resize(function (){
		
		var frame_height = Number($("#height").val());
		
		var form_width = Number($("#form1").width());
		var title_width = Number($("#td_title").width());		
		var title_height = Number($(".left_header_table").height());
		
		$(".left_contents_div").css("height", (frame_height - title_height) -32 ) ;	
		$(".right_contents_div").css("height", (frame_height - title_height) -32 );
		
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

<table border="0" cellspacing="0" cellpadding="0" width='1600'>
    <tr id='tr_title' style='position:relative;z-index:1'>
        <td class='' width='480' id='td_title' >  	
            <div id="left_header" class="left_header_div" style="width:490px;">			        
    	        <table  class="left_header_table" border="0" cellspacing="1" cellpadding="0" width='100%' height="34">
                    <tr> 
                        <td width='50' class='title'>연번</td>
                        <td width='50' class='title'>구분</td>
        		        <td width="50" class='title'>견적</td>
                        <td width='70' class='title'>영업담당자</td>
                        <td width="110" class='title'>계약번호</td>
                        <td width="150" class='title'>고객</td>					
                    </tr>
                </table>
            </div>
            <div id="left_contents" class="left_contents_div" style="width:490px;" onmousewheel="fixDataOnWheel()" onScroll="dataOnScroll()">  
                <table class="left_contents_table"  border="0" cellspacing="1" cellpadding="0" width='100%'>
                    <%if(cont_size > 0){%>
                    <%	for(int i = 0 ; i < cont_size ; i++){
    						Hashtable ht = (Hashtable)vt.elementAt(i);
    						String td_color = "";
    						if(String.valueOf(ht.get("USE_YN")).equals("N")) td_color = "class='is'";    				
    						//if(String.valueOf(ht.get("RENT_L_CD")).equals("K314HBHR00090")) continue;
    	            %>
                    <tr> 
                        <td <%=td_color%> width='50' align='center'><%=i+1%></td>
                        <td <%=td_color%> width='50' align='center'><%=ht.get("USE_YN")%></td>		  
        		        <td <%=td_color%> width='50' align='center'><%=ht.get("BC_EST_YN")%></td>		  
        		        <td <%=td_color%> width='70' align='center'><%=ht.get("USER_NM")%></td>		  		  
                        <td <%=td_color%> width='110' align='center'><a href="javascript:parent.view_cont('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("RENT_ST")%>', '<%=ht.get("ADD_RENT_ST")%>')" onMouseOver="window.status=''; return true" title='계약약식내역'><%=ht.get("RENT_L_CD")%></a></td>		  
        		        <td <%=td_color%> width='150' align='center'><span title='<%=ht.get("FIRM_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("FIRM_NM")), 9)%></span></td>		  		  					
                    </tr>
                    <%	}	%>                
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
	            <table class="right_header_table" border="0" cellspacing="1" cellpadding="0" width='100%' height="34">   
		       		<colgroup>
		       			<col width="150">
		       			<col width="90">
		       			<col width="70">
		       			<col width="70">		       			
		       			<col width="70">		       					       		
		       			<col width="70">
		       			<col width="90">
		       			<col width="90">
		       			<col width="90">
		       			<col width="90">
		       			<col width="90">
		       			<col width="90">
		       			<col width="60">
		       		</colgroup>        
        		    <tr>
        		        <td width="150" class='title'>차종</td>
        		        <td width="90" class='title'>차량번호</td>
        	            <td width='70' class='title'>차량구분</td>		  
        	            <td width='70' class='title'>계약구분</td>
        	            <td width='70' class='title'>용도구분</td>        	            		 
        	            <td width='70' class='title'>약정기간</td>
        	            <td width='90' class='title'>견적일자</td>		  
        	            <td width='90' class='title'>대여개시일</td>        	            
        		        <td width='90' class='title'>견적대여료</td>
        		        <td width='90' class='title'>기준대여료(c)</td>
        		        <td width='90' class='title'>정상대여료(g)</td>
        		        <td width='90' class='title'>계약대여료(h)</td>
        		        <td width='60' class='title'>등록자</td>
        		    </tr>
	            </table>
	        </div>
		    <div id="right_contents" class="right_contents_div" onScroll="dataOnScroll()">
		        <table class="right_contents_table" border="0" cellspacing="1" cellpadding="0" width='100%'>    	        
                    <%if(cont_size > 0){%>
                    <%	for(int i = 0 ; i < cont_size ; i++){
    						Hashtable ht = (Hashtable)vt.elementAt(i);
    						String td_color = "";
	    					if(String.valueOf(ht.get("USE_YN")).equals("N")) td_color = "class='is'";    				
    						//if(String.valueOf(ht.get("RENT_L_CD")).equals("K314HBHR00090")) continue;
    	            %>
                    <tr>
        		        <td <%=td_color%> width='150' align='center'><span title='<%=ht.get("CAR_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("CAR_NM")), 10)%></span></td>
        		        <td <%=td_color%> width='90' align='center'><%=ht.get("CAR_NO")%></td>					
        		        <td <%=td_color%> width='70' align='center'><%=ht.get("CAR_GU")%></td>
        		        <td <%=td_color%> width='70' align='center'><%=ht.get("CONT_ST")%></td>		  		  
        		        <td <%=td_color%> width='70' align='center'><%=ht.get("CAR_ST")%></td>        		    
        		        <td <%=td_color%> width='70' align='center'><%=ht.get("CON_MON")%></td>
        		        <td <%=td_color%> width='90' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%></td>		  
        		        <td <%=td_color%> width='90' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT")))%></td>
        		        <td <%=td_color%> width='90' align='right'><%=Util.parseDecimal(String.valueOf(ht.get("INV_S_AMT")))%>원</td>		  
        		        <td <%=td_color%> width='90' align='right'><%=Util.parseDecimal(String.valueOf(ht.get("BC_S_C")))%>원</td>
        		        <td <%=td_color%> width='90' align='right'><%=Util.parseDecimal(String.valueOf(ht.get("BC_S_G")))%>원</td>
        		        <td <%=td_color%> width='90' align='right'><%=Util.parseDecimal(String.valueOf(ht.get("FEE_S_AMT")))%>원</td>
        		        <td <%=td_color%> width='60' align='center'><%=ht.get("REG_ID")%></td>
        		    </tr>
                    <%	}	%>
                    <%} else  {%>  
		       	    <tr>
			            <td align='center'>&nbsp;</td>
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


