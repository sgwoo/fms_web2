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
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	//chrome ���� 
	String height = request.getParameter("height")==null?"":request.getParameter("height");
	
	
	int count =0;
	
	
	
	
	Vector vt = new Vector();
	
	//if(!t_wd.equals("")){
		vt = a_db.getContRmList_20160204(s_kd, t_wd, andor, gubun1, gubun2, gubun3, gubun4, gubun5, st_dt, end_dt);
	//}
	int cont_size = vt.size();

%>

<html style="overflow: hidden;">
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>

<script type="text/javascript">
$('document').ready(function() {
	//div�� ȭ�� ���ð����� �ʱ�ȭ
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
		
	//������ ��������� width, height�� ����
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
	
		//���̾ƿ� ��ũ�� ����
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

<table border="0" cellspacing="0" cellpadding="0" width="1420">  
     <tr id='tr_title' style='position:relative;z-index:1'>
       <td class='' width='520' id='td_title' >  
          <div id="left_header" class="left_header_div" style="width:530px;">		      
	   	    <table class="left_header_table" border="0" cellspacing="1" cellpadding="0" width='100%' height="60">
	               <tr> 
	                    <td width='40' class='title'>����</td>
                    <td width='40' class='title'>����</td>
                    <td width='40' class='title'>����</td>
        	    		<td width="40" class='title'>��ĵ</td>	        		  
                    <td width='130' class='title'>����ȣ</td>
                    <td width='80' class='title'>�����</td>
                    <td width="150" class='title'>����</td>
	               </tr>
	           </table>
        </div>

	   <div id="left_contents" class="left_contents_div" style="width: 530px;" onmousewheel="fixDataOnWheel()" onScroll="dataOnScroll()">  
         <table class="left_contents_table"  border="0" cellspacing="1" cellpadding="0" width='100%'>
	     <%if(cont_size > 0){%>
	       <%	for(int i = 0 ; i < cont_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				String td_color = "";
				if(String.valueOf(ht.get("USE_YN")).equals("N")) td_color = "class='is'";				
    				count++;
    		%>
                <tr> 
                    <td <%=td_color%> width='40' align='center'><a href="javascript:parent.view_memo('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true" title='��ȭ����'><%=count%></a></td>
                    <td <%=td_color%> width='40' align='center'><%if(String.valueOf(ht.get("USE_YN")).equals("")){%>���<%}else if(String.valueOf(ht.get("USE_YN")).equals("Y")){%>����<%}else if(String.valueOf(ht.get("USE_YN")).equals("N")){%>����<%}%></td>		
                    <td <%=td_color%> width='40' align='center'><a href="javascript:parent.view_sms_send('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true" title='���ڹ߼�'><img src=/acar/images/center/icon_tel.gif align=absmiddle border=0></a></td>		          	    
        	  	    <td <%=td_color%> width='40' align='center'><a href="javascript:parent.view_scan('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true" title='��ĵ����'><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></td>		          	  
                    <td <%=td_color%> width='130' align='center'><a href="javascript:parent.view_cont('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("USE_YN")%>', '<%=ht.get("CAR_ST")%>', '', '<%=ht.get("REG_STEP")%>')" onMouseOver="window.status=''; return true" title='���󼼳���'><%=ht.get("RENT_L_CD")%></a></td>
                    <td <%=td_color%> width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_DT")))%></td>
                    <td <%=td_color%> width='150' align='center'><a href="javascript:parent.view_client('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("FEE_RENT_ST")%>')" onMouseOver="window.status=''; return true" title='����ĳ���'><span title='<%=ht.get("FIRM_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("FIRM_NM")), 9)%></span></a></td>
                </tr>
             <%		}	%>
         <%} else  {%>  
	           	<tr>
			           <td align='center'>��ϵ� ����Ÿ�� �����ϴ�</td>
			    </tr>	              
	     <%}	%>
            </table>
           </div>            
	    </td>
        <td>			
		     <div id="right_header" class="right_header_div custom_scroll">
	            <table class="right_header_table" border="0" cellspacing="1" cellpadding="0" width='100%' height="60">   
		       		<colgroup>
		       			<col width="150">
		       			<col width="100">
		       	
		       			<col width="70"> <!-- ����  rowspan -->
		       					       			
		       			<col width="140">
		       			<col width="80">
		       			<col width="80">
		       			
		       			<col width="70">
		       			<col width="70">			       			
		       			<col width="70">		       			
		       			<col width="70">		       			
		       		</colgroup>
		       		<tr>
	                 	<td colspan="2" class='title'>�ڵ���</td>		
		        	    <td rowspan="2" width="70" class='title'>�����</td>
		        	    <td colspan="3" class='title'>���</td>
		        	    <td colspan="4" class='title'>����</td>		  
	        	    </tr>
	        		<tr>
	        		  	<td width="150" class='title'>����</td>
		        	    <td width="100" class='title'>������ȣ</td>
		        	   
		        	    <td width='140' class='title'>�Ⱓ</td>
		        	    <td width='80' class='title'>�뿩������</td>
		        	    <td width='80' class='title'>�뿩������</td>
		        	   
		        	    <td width='70' class='title'>���ʿ�����</td>
		        	    <td width='70' class='title'>�����븮��</td>
		        	    <td width='70' class='title'>���������</td>
		        	    <td width='70' class='title'>���������</td>      
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
		%>
        	<tr>
        	    <td <%=td_color%> width='150' align='center'><span title='<%=ht.get("CAR_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("CAR_NM")), 10)%></span></td>
        	    <td <%=td_color%> width='100' align='center'><a href="javascript:parent.view_car('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("CAR_MNG_ID")%>')" onMouseOver="window.status=''; return true" title='�ڵ�����ϳ���'><%=ht.get("CAR_NO")%></a></td>	
        	    <td <%=td_color%> width='70' align='center'><span title='<%=ht.get("INS_COM_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("INS_COM_NM")), 4)%></span></td>		  		  
        	    <td <%=td_color%> width='140' align='center'><%=ht.get("CON_MON")%>����<%if(!String.valueOf(ht.get("CON_DAY")).equals("") && !String.valueOf(ht.get("CON_DAY")).equals("0")){%><%=ht.get("CON_DAY")%>��<%}%><%if(String.valueOf(ht.get("EXT_ST")).equals("����")){%>(<%=ht.get("EXT_MON")%>����<%if(!String.valueOf(ht.get("EXT_DAY")).equals("") && !String.valueOf(ht.get("EXT_DAY")).equals("0")){%><%=ht.get("EXT_DAY")%>��<%}%>)<%}%></td>
        	    <td <%=td_color%> width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT")))%></td>
        	    <td <%=td_color%> width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_END_DT")))%></td>
        	    <td <%=td_color%> width='70' align='center'><%=ht.get("BUS_NM")%></td>        		  
        	    <td <%=td_color%> width='70' align='center'><%=ht.get("BUS_AGNT_NM")%></td>        		  
        	    <td <%=td_color%> width='70' align='center'><%=ht.get("BUS_NM2")%></td>
        	    <td <%=td_color%> width='70' align='center'><%=ht.get("MNG_NM")%></td>
        	</tr>
  	 <%		}	%> 		
      <%} else  {%>  
		       	<tr>
			       <td width="900" colspan="10" align='center'>&nbsp;</td>
			     </tr>	              
	   <%}	%>
		    </table>
	  	  </div>
	    </td>
    </tr>
</table>
</form>
</body>

<script language='javascript'>
<!--
	parent.document.form1.size.value = '<%=count%>';
//-->
</script>

</html>

