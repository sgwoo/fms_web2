<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.forfeit_mng.*, acar.user_mng.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"3":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	
	CommonDataBase c_db = CommonDataBase.getInstance();	
	
	Vector fines = FineDocDb.getFineDocLists("손해", br_id, gubun1, gubun2, gubun3, gubun4, "", st_dt, end_dt, s_kd, t_wd, sort, asc);
	int fine_size = fines.size();
	

	int sub_size = 0;
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
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
	
	//전체선택
	function AllSelect(){
		var fm = document.form1;
		var len = fm.elements.length;
		var cnt = 0;
		var idnum ="";
		for(var i=0; i<len; i++){
			var ck = fm.elements[i];
			if(ck.name == "ch_l_cd"){		 
				if(ck.checked == false){
					ck.click();
				}else{
					ck.click();
				}
			}	
		}
		return;
	}	
	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:init()">

<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='doc_cnt' value=''>
<input type='hidden' name='fee_size' value='<%=fine_size%>'>
<table border="0" cellspacing="0" cellpadding="0" width='100%'>
	<tr><td class=line2 colspan=2></td></tr>
    <tr id='tr_title' style='position:relative;z-index:1'>
	    <td class='line' width='45%' id='td_title' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td class='title' width="8%"><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>
                    <td class='title' width="8%">연번</td>
                    <td width='21%' class='title'>문서번호</td>
                    <td width='21%' class='title'>시행일자</td>
                    <td width='42%' class='title'>수신처</td>
                </tr>
            </table>
	    </td>
	    <td class='line' width='55%'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td class='title' width="25%">참조</td>
                    <td class='title' width="40%">주소</td>
                    <td class='title' width="10%">건수</td>					
                    <td class='title' width="10%">등록자</td>
                    <td class='title' width="15%">등록일</td>						
                </tr>
            </table>
	    </td>
    </tr> 
    <tr>
    	<td class='line' width='45%' id='td_con' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
              <%for(int i = 0 ; i < fine_size ; i++){
    				Hashtable ht = (Hashtable)fines.elementAt(i);%>
                <tr> 
					<td  align='center' width="8%"><input type="checkbox" name="ch_l_cd" value="<%=ht.get("DOC_ID")%><%=ht.get("CNT")%>"></td>
                    <td  align='center' width="8%"><%=i+1%></td>
                    <td  width='21%' align='center'><a href="javascript:parent.view_fine_doc('<%=ht.get("DOC_ID")%>')" onMouseOver="window.status=''; return true"><%=ht.get("DOC_ID")%></a></td>
                    <td  width='21%' align='center'><%=AddUtil.getDate3(String.valueOf(ht.get("DOC_DT")))%></td>
                    <td  width='42%' align='center'><span title="<%=ht.get("GOV_NM")%>"><%=Util.subData(String.valueOf(ht.get("GOV_NM")), 12)%></span></td>
                </tr>
              <%}%>
    		  <%if(fine_size==0){%>
                    <td  align='center'>등록된 데이타가 없습니다.</td>		  
              <%}%>		  
            </table>
    	</td>
    	<td class='line' width='55%'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
              <%for(int i = 0 ; i < fine_size ; i++){
    				Hashtable ht = (Hashtable)fines.elementAt(i);%>
                <tr> 
                    <td align="center" width="25%"><span title="<%=ht.get("MNG_DEPT")%> <%=ht.get("MNG_NM")%> <%=ht.get("MNG_POS")%>"><%=Util.subData(String.valueOf(ht.get("MNG_DEPT"))+""+String.valueOf(ht.get("MNG_NM"))+""+String.valueOf(ht.get("MNG_POS")), 15)%></span></td>
                    <td  width='40%' align='center'><span title="<%=ht.get("GOV_ADDR")%>"><%=Util.subData(String.valueOf(ht.get("GOV_ADDR")), 20)%></span></td>			
                    <td align="center" width="10%"><%=ht.get("CNT")%>건</td>					
                    <td align="center" width="10%"><%=c_db.getNameById(String.valueOf(ht.get("REG_ID")), "USER")%></td>			
                    <td align="center" width="15%"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%></td>						
                </tr>
              <%
			  		sub_size = sub_size + Util.parseInt(String.valueOf(ht.get("CNT")));
			  	}%>		  
    		  <%if(fine_size==0){%>
                    <td  align='center'></td>		  
              <%}%>				  
            </table>
    	</td>
    </tr>
</table>
<input type='hidden' name='sub_size' value='<%=sub_size%>'>
</form>
</body>
</html>
