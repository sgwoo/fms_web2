<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.ext.*"%>
<%@ page import="acar.common.*"%>
<jsp:useBean id="ae_db" scope="page" class="acar.ext.AddExtDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	String ven_code = request.getParameter("r_ven_code")==null?"":request.getParameter("r_ven_code");
			
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	Vector clss = ae_db.getClsFeeScdList(brch_id, "", "6", "3", "", "", "", "", "", "", "0", "", "");
	int cls_size = clss.size();
	
	String aa = "";
	String bb = "";
		
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
                      <td width='3%' class='title' style='height:45'> <input type="checkbox" name="all_pr" value="Y" onClick='javascript:AllSelect(this.form.pr)'> </td>
                        <td width='4%' class='title'>연번</td>
                    	 <td width='7%' class='title'>계약번호</td>
                        <td width='7%' class='title'>차량번호</td>
                        <td width='12%' class='title'>차명</td>
                        <td width=20% class='title'>상호</td>  
                        <td width=10% class='title'>해지일</td>  
                        <td width=10% class='title'>회차</td>  
                        <td width=10% class='title' >금액</td>								  
                        <td width=7% class='title' >보증보험</td>        
                        <td width=7% class='title' >영업담당</td>              

                </tr>                
        
 <%	if(cls_size > 0){%>
     <%		for (int i = 0 ; i < cls_size ; i++){
			Hashtable cls = (Hashtable)clss.elementAt(i);
			
			aa = Util.replace(Util.parseDecimal(String.valueOf(cls.get("GI_AMT"))), "," ,"");
			bb = String.valueOf(cls.get("TM")) + "" +  String.valueOf(cls.get("TM_ST"));
						
	%>
                 <tr> 
                                <td width='3%' align='center'> <input type="checkbox" name="pr" value="<%=cls.get("RENT_MNG_ID")%>^<%=cls.get("RENT_L_CD")%>^<%=cls.get("CAR_MNG_ID")%>^<%=cls.get("AMT")%>^<%=bb%>^<%=aa%>^" > 
                                </td>
                                <td width='4%' align='center'><%=i+1%></td>
                                <td width='7%' align='center'><%=cls.get("RENT_L_CD")%></td>			
                                <td width='7%' align='center'><%=cls.get("CAR_NO")%></td>          
                                <td width='12%' align='center'><span title='<%=cls.get("CAR_NM")%> <%=cls.get("CAR_NAME")%>'><%=Util.subData(String.valueOf(cls.get("CAR_NM"))+" "+String.valueOf(cls.get("CAR_NAME")), 9)%></span></td>							     </td>
								<td width='20%' align='center'><%=Util.subData(String.valueOf(cls.get("FIRM_NM")), 10)%></td>                          
	                            <td width='10%' align='center' ><%=AddUtil.ChangeDate2(String.valueOf(cls.get("CLS_DT")))%></td>
	                            <td width='10%' align='center' ><%=cls.get("TM")%><%=cls.get("TM_ST")%></td>
	                            <td width='10%' align='right'><%=Util.parseDecimal(String.valueOf(cls.get("AMT")))%></td>							
                                <td width='7%' align='right'><%=Util.parseDecimal(String.valueOf(cls.get("GI_AMT")))%></td>
                                <td width='7%' align='center'><%=c_db.getNameById(String.valueOf(cls.get("BUS_ID2")), "USER")%></td>
                            								     
                      </tr>
      <%}%>
                   
 <%}%>                         
                 
            </table>
        </td>
    </tr>
</table>


</form>
</body>
</html>
