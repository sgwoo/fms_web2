<%@ page language="java" contentType="text/html; charset=euc-kr"%>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.cus_bus.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String dt = "2";
	String ref_dt1 = Util.getDate();
	String ref_dt2 = Util.getDate();
	
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	
	if(request.getParameter("auth_rw") != null)	auth_rw = request.getParameter("auth_rw");
	if(request.getParameter("dt") != null)	dt = request.getParameter("dt");
	if(request.getParameter("ref_dt1") != null)	ref_dt1 = request.getParameter("ref_dt1");
	if(request.getParameter("ref_dt2") != null)	ref_dt2 = request.getParameter("ref_dt2");
	
	CusBus_Database cb_db = CusBus_Database.getInstance();

	Vector conts =  cb_db.getContList_c(dt, ref_dt1, ref_dt2, gubun1, gubun2, gubun3, gubun4, sort);
		
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//담당자 리스트
	Vector users = c_db.getUserList("", "", "EMP"); 
	int user_size = users.size();
	
	//퇴사자(영업담당자) 리스트
	Vector users2 = c_db.getUserList("", "", "", "N");
	int user_size2 = users2.size();
	
%>
<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
function set_mng(mode,rmg,rld){
	var SUBWIN="./cus_mng_set.jsp?rent_mng_id="+rmg+"&rent_l_cd="+rld+"&mode="+mode;
	window.open(SUBWIN, "setMng", "left=650, top=200, width=200, height=100, scrollbars=no");
}	

	//등록하기
function save(){
		fm = document.form1;
		
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_all"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}	
		if(cnt == 0){
		 	alert("담당자변경할 계약을 선택하세요.");
			return;
		}	
		
	//	if(fm.new_value.value == ""){		alert("변경후를 입력해 주세요!");		fm.new_value.focus();	return;	}
		if(fm.cng_cau.value == ""){			alert("변경사유를 입력해 주세요!");		fm.cng_cau.focus();		return;	}
				
		if(!confirm("등록하시겠습니까?"))	return;
		fm.action = 'cng_mng_id_a.jsp';
		fm.submit();
}

	//전체선택
	function AllSelect(){
		var fm = document.form1;
		var len = fm.elements.length;
		var cnt = 0;
		var idnum ="";
		for(var i=0; i<len; i++){
			var ck = fm.elements[i];
			if(ck.name == "ch_all"){
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
<body>
<form name="form1">
 <input type='hidden' name="cng_item" 		value="mng_id">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>관리담당자 변경</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td align="right">
		    <table border="0" cellspacing="1" cellpadding="0" width=100%>
    		    <tr>
    			    <td width="10%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_bgj.gif align=absmiddle></td>
    			    <td>&nbsp;<%=c_db.getNameById(gubun4, "USER")%> 
    			    <input type='hidden' name="old_value" value="<%=gubun4%>">				  
    			    </td>			  
    			</tr>		
    		    <tr>
    			    <td width="10%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_bgh.gif align=absmiddle></td>
    			    <td>			  				
                    <select name="new_value">
        				<option value="">미지정</option>	
                        <%for(int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i); 
        						if(String.valueOf(user.get("USER_NM")).equals("명진공업사"))  continue;%>
                        <option value='<%=user.get("USER_ID")%>' ><%=user.get("USER_NM")%></option>
                        <%}%>    			  		
                    </select>	
    				  			  
    			    </td>			  
    			</tr>		
    		    <tr>
    			    <td width="10%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_bgsy.gif align=absmiddle></td>
    			    <td>
    			    <input type='text' name='cng_cau' size='60' class='text' value='' style='IME-MODE: active'></td>			  
     		    </tr>
 			 </table>
 		 </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>		 	   
    <tr>
        <td>
	        <table width="100%" border="0" cellspacing="0" cellpadding="0">
	            <tr>
	                <td class=line2></td>
	            </tr>
                <tr>
                    <td class="line">
            		    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                            <tr> 
                                <td width='4%' rowspan="2" class='title'>연번</td>
                                <td width='2%' rowspan="2" class='title'><input type="checkbox" name="ch_bx" value="Y" onclick="javascript:AllSelect();"></td>
                                <td width='10%' rowspan="2" class='title'>계약번호</td>
                                <td rowspan="2" class='title'>상호</td>
                                <td width='10%' rowspan="2" class='title'>차량번호</td>
                                <td width='10%' rowspan="2" class='title'>차종</td>
                                <td width='8%' rowspan="2" class='title'>계약일</td>
                                <td width='7%%' rowspan="2" class='title'>관리<br>구분</td>
                                <td width='6%%' rowspan="2" class='title'>용도<br>구분</td>
                                <td width='5%%' rowspan="2" class='title'>대여<br>
                                개월</td>
                                <td colspan="3" class='title'>담당자</td>
                            </tr>
                            <tr>
                                <td width='6%' class='title'>최초영업</td>
                                <td width='6%' class='title'>영업</td>
                                <td width='6%' class='title'>관리</td>                             
                            </tr>
                        </table>
        		    </td>
                </tr>
            </table>    
        </td>
    </tr>  
    <tr> 
        <td class="line">
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
        <% if(conts.size()>0){
		  		for(int i=0; i<conts.size(); i++){
					RentListBean cont = (RentListBean)conts.elementAt(i); %>
                <tr> 
                    <td width='4%' align='center'><%= i+1 %></td>
                    <td width='2%' align='center'>
                        <input type="checkbox" name="ch_all" value="<%=cont.getRent_mng_id()%>^<%=cont.getRent_l_cd()%>^" >
                    </td> 
                    <td width='10%' align='center'><%= cont.getRent_l_cd() %></td>
                    <td align='left'>&nbsp;<span title='<%= cont.getFirm_nm() %>'><%= AddUtil.subData(cont.getFirm_nm(),16) %></span></td>
                    <td width='10%' align='center'><%= cont.getCar_no() %></td>
                    <td width='10%' align='left'>&nbsp;<span title="<%= cont.getCar_nm() %>"><%= AddUtil.subData(cont.getCar_nm(),10) %></span></td>
                    <td width='8%' align='center'><%= cont.getRent_dt() %></td>
                    <td width='7%' align='center'><%= cont.getRent_way() %></td>
                    <td width='6%' align='center'> 
                    <% if(cont.getCar_st().equals("1")) out.print("렌트");
        		  						else if(cont.getCar_st().equals("2")) out.print("보유");
        								else if(cont.getCar_st().equals("3")) out.print("리스"); %>
                    </td>
                    <td width='5%' align='center'><%= cont.getCon_mon() %></td>
                    <td width='6%' align='center'><%= c_db.getNameById(cont.getBus_id(),"USER") %></td>
                    <td width='6%' align='center'><%= c_db.getNameById(cont.getBus_id2(),"USER") %></td>
                    <td width='6%' align='center'><% if(cont.getMng_id().equals("")){ %>
        		 <!-- 		<a href="javascript:set_mng('1','<%= cont.getRent_mng_id() %>','<%= cont.getRent_l_cd() %>');"> -->미지정 <!-- </a> -->
        			<% }else{ %>
        				<%= c_db.getNameById(cont.getMng_id(),"USER") %>
        			<% } %></td>
        			
                 		
                </tr>
                <% 		}
        		}else{ %>
                <tr> 
                    <td colspan="13" align='center'>해당 계약건이 없습니다.</td>
                </tr>
        <% } %>
            </table>
        </td>
    </tr>  
    <tr>
	    <td> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
            		<td align='right'>
            		  <a href="javascript:save()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_reg.gif"  align="absmiddle" border="0"></a>&nbsp;&nbsp;
            		  <a href='javascript:window.close();' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_close.gif"  align="absmiddle" border="0"></a>
            		</td>	
		        </tr>
		    </table>
        </td>    	
    </tr>	
</table>
</form>
</body>
</html>
