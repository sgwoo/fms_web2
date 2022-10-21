<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*"%>
<jsp:useBean id="ec_db" scope="page" class="acar.cont.EtcContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?	"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?	"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?	"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?	"":request.getParameter("end_dt");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
		
	int count =0;
	
	
	Vector vt = ec_db.getEcarPurSubList(s_kd, t_wd, gubun1, gubun2, gubun3);
	int cont_size = vt.size();
	
	long total_amt1 	= 0;
	long total_amt2 	= 0;	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	/* Title ���� */
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
	
	//��ĵ���� ���� - ���¾�ü �ڵ����������
	function openP(c_id){
		window.open("/fms2/master_car/view_scan.jsp?c_id="+c_id, "VIEW_SCAN", "left=100, top=100, width=720, height=350, scrollbars=yes");		
	}	
	
	//��ü����
	function AllSelect(){
		var fm = document.form1;
		var len = fm.elements.length;
		var cnt = 0;
		var idnum ="";
		for(var i=0; i<len; i++){
			var ck = fm.elements[i];
			if(ck.name == "ch_cd"){
				if(ck.checked == false){
					ck.click();
				}else{
					ck.click();
				}
			}
		}
	}			
//-->
</script>
</head>
<body onLoad="javascript:init()">
	<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>
  <input type='hidden' name='br_id' value='<%=br_id%>'>
  <input type='hidden' name='s_kd' value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' value='<%=t_wd%>'>
  <input type='hidden' name='andor' value='<%=andor%>'>
  <input type='hidden' name='gubun1' value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' value='<%=gubun2%>'>
  <input type='hidden' name='gubun3' value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' value='<%=gubun4%>'>
  <input type='hidden' name='gubun5' value='<%=gubun5%>'>
  <input type='hidden' name='st_dt' value='<%=st_dt%>'>
  <input type='hidden' name='end_dt' value='<%=end_dt%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='/fms2/lc_rent/ecar_pur_sub_frame.jsp'>  
  <input type='hidden' name='ext_est_dt' value=''>  
<table border="0" cellspacing="0" cellpadding="0" width='1540'>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>		
        <td class='line' width='400' id='td_title' style='position:relative;'> 
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                  <td width='30' class='title'>����</td>
                  <td width='30' class='title'><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>
                  <td width='100' class='title'>����ȣ</td>
                  <td width='90' class='title'>�������</td>
                  <td width="150" class='title'>��</td>                  
                </tr>
            </table>
    	</td>
	    <td class='line' width='1140'>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        	    <tr>
        	    	    <td width="100" class='title'>������</td>
        		        <td width="200" class='title'>����</td>
        		        <td width="100" class='title'>�������Ű���</td>
        		        <td width="80" class='title'>�ΰ���</td>
        		        <td width="90" class='title'>������ȣ</td>
        		        <td width="150" class='title'>�����ȣ</td>
        	          <td width='90' class='title'>���ʵ����</td>
        	          <td width='90' class='title'>���ź�����</td>
        	          <td width='90' class='title'>û������</td>
        	          <td width='90' class='title'>�Ա�����</td>
        	          <td width='60' class='title'>�����</td>
        	    </tr>
	        </table>
	    </td>
    </tr>
  <%if(cont_size > 0){%>
    <tr>		
        <td class='line' width='400' id='td_con' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
            <%	for(int i = 0 ; i < cont_size ; i++){
									Hashtable ht = (Hashtable)vt.elementAt(i);
									String td_color = "";
									if(String.valueOf(ht.get("USE_YN")).equals("N")) td_color = "class='is'";
    				%>
                <tr> 
                  <td <%=td_color%> width='30' align='center'><%=i+1%></td>
                  <td  width='30' align='center'>
		                  <%if(!String.valueOf(ht.get("INIT_REG_DT")).equals("") && AddUtil.parseLong(String.valueOf(ht.get("EXT_S_AMT")))>0 && String.valueOf(ht.get("EXT_EST_DT")).equals("")){%>
		                  <input type="checkbox" name="ch_cd" value="<%=ht.get("RENT_MNG_ID")%><%=ht.get("RENT_L_CD")%>">
		                  <%}%>
		              </td>
                  <td <%=td_color%> width='100' align='center'><%=ht.get("RENT_L_CD")%></td>
                  <td <%=td_color%> width='90' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("DLV_DT")))%></td>
                  <td <%=td_color%> width='150' align='center'><span title='<%=ht.get("FIRM_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("FIRM_NM")), 10)%></span></td>
                </tr>
        <%		}	%>
                <tr> 
                    <td class="title" align='center' colspan='5'>�հ�</td>
                </tr>        
            </table>
	    </td>
	    <td class='line' width='1140'>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        		<%	for(int i = 0 ; i < cont_size ; i++){
									Hashtable ht = (Hashtable)vt.elementAt(i);
									String td_color = "";
									if(String.valueOf(ht.get("USE_YN")).equals("N")) td_color = " class=is ";
									total_amt1 	= total_amt1 + AddUtil.parseLong(String.valueOf(ht.get("EXT_S_AMT")));
						%>
        		<tr>        		  
        			<td <%=td_color%> width='100' align='center'><span title='<%=ht.get("NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("NM")), 5)%></span></td> 
        		  <td <%=td_color%> width='200' align='center'><span title='<%=ht.get("CAR_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("CAR_NM")), 15)%></span></td>
        		  <td <%=td_color%> width='100' align='right'><%=Util.parseDecimal(String.valueOf(ht.get("CAR_FS_AMT")))%></td>
        		  <td <%=td_color%> width='80' align='right'><%=Util.parseDecimal(String.valueOf(ht.get("CAR_FV_AMT")))%></td>
        		  <td <%=td_color%> width='90' align='center'><%=ht.get("CAR_NO")%></td>
        		  <td <%=td_color%> width='150' align='center'><%=ht.get("CAR_NUM")%></td>
        		  <td <%=td_color%> width='90' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("INIT_REG_DT")))%></td>
        		  <td <%=td_color%> width='90' align='right'><%=Util.parseDecimal(String.valueOf(ht.get("EXT_S_AMT")))%></td>
        		  <td <%=td_color%> width='90' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("EXT_EST_DT")))%></td>
        		  <td <%=td_color%> width='90' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("EXT_PAY_DT")))%></td>
        		  <td <%=td_color%> width='60' align='center'>
        		    <%if(!String.valueOf(ht.get("ATTACH_SEQ")).equals("")){%>
        		    <a href="javascript:openPopP('image/jpeg','<%=ht.get("ATTACH_SEQ")%>');" title='����'><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a>        		  	
        		  	<%}%>
        		  </td>
        		</tr>
						<%	}	%>
                <tr> 
                    <td class="title" colspan='7'>&nbsp;</td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt1)%></td>
                    <td class="title" colspan='3'>&nbsp;</td>
                </tr>
	        </table>
	    </td>
<%	}else{	%>                     
    <tr>		
        <td class='line' width='400' id='td_con' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td align='center'><%if(t_wd.equals("")){%>�˻�� �Է��Ͻʽÿ�.<%}else{%>��ϵ� ����Ÿ�� �����ϴ�<%}%></td>
                </tr>
            </table>
	    </td>
	    <td class='line' width='1140'>
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
</body>
</html>


