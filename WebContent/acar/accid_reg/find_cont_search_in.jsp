<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.accid.*"%>
<%@ page import="acar.common.*"%>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	
	//자산양수차량 
	AccidDatabase as_db = AccidDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
		
	Vector vt = as_db.getRentCommList("", gubun, gubun_nm);
	int vt_size = vt.size();	

%>
	

<html>
<head><title>FMS</title>
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

	var checkflag = "false";
	
	function AllSelect(field){
		if(checkflag == "false"){
			for(i=0; i<field.length; i++){
				field[i].checked = true;
			}
			checkflag = "true";
			return;
		}else{
			for(i=0; i<field.length; i++){
				field[i].checked = false;
			}
			checkflag = "false";
			return;
		}
	}
	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>

<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line"> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                      <td width='5%' class='title' style='height:51'> <input type="checkbox" name="all_pr" value="Y" onClick='javascript:AllSelect(this.form.pr)'> </td>
                        <td width='6%' class='title'>연번</td>
                        <td width='10%' class='title'>차량번호</td>
                        <td width='*' class='title'>차명</td>
                        <td width=15% class='title' >연료</td>
                        <td width=12% class='title' >최초등록일</td>								  
                        <td width=12% class='title' >계약일</td>
                         <td width=14% class='title' >관리번호</td>				  

                </tr>                
        
    <% 		for (int i = 0 ; i < vt_size ; i++){
								Hashtable ht = (Hashtable)vt.elementAt(i);										
	%>
                 <tr> 
                                <td width='5%' align='center'><input type="checkbox" name="pr" value="<%=String.valueOf(ht.get("CAR_MNG_ID"))%>^<%=String.valueOf(ht.get("RENT_MNG_ID"))%>^<%=String.valueOf(ht.get("RENT_L_CD"))%>^" ></td>
                                <td width='6%' align='center'><%=i+1%></td>
                                <td width='10%' align='center'><%=ht.get("CAR_NO")%></td>			                              
                                <td width='*' align='left'><%=ht.get("CAR_NM")%></td>
								<td width='15%' align='center' ><%=c_db.getNameByIdCode("0039", "", String.valueOf(ht.get("FUEL_KD")))%></td>
                                <td width='12%' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("INIT_REG_DT")))%></td>		
                                <td width='12%' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("BASE_DT")))%></td>											
                                <td width='14%' align='center'><%=ht.get("CAR_DOC_NO")%></td>
								     
                      </tr>
      <%}%>
                     
                 
            </table>
        </td>
    </tr>
</table>


</form>
</body>
</html>
