<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_scrap.*"%>
<jsp:useBean id="sc_db" scope="page" class="acar.car_scrap.ScrapDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String gubun = request.getParameter("gubun")==null?"서울":request.getParameter("gubun");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	int count =0;
	
	Vector scrs = sc_db.getScrapList_m(gubun, s_kd, t_wd);
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<!-- <script language="JavaScript" src='/include/common.js'></script> -->
<script language="JavaScript">
<!--	
//차량번호 이력
function car_no_history(car_no)
{	
	window.open("./car_no_history.jsp?car_no="+car_no, "NO_HIS", "left=150, top=100, width=920, height=300");
}
//대폐차 수정/삭제
function updateCar_scarp(seq, car_no, car_nm, reg_dt, car_ext){
	<%if(from_page.equals("")){%>
	<% 	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){ %>
	parent.document.form1.seq.value = seq;
	parent.document.form1.car_no.value = car_no;
	parent.document.form1.car_nm.value = car_nm;
	parent.document.form1.reg_dt.value = reg_dt;		
	parent.document.form1.car_ext.value = car_ext;		
	<%	}%>
	<%}else{%>
	parent.parent.opener.form1.est_car_no.value 	= car_no;
	parent.parent.window.close();
	<%}%>
}

function deleteCar_scrap(){
	var fm = document.form1;
	var len=fm.elements.length;
	var cnt=0;
	var idnum="";
	for(var i=0 ; i<len ; i++){
		var ck=fm.elements[i];		
		if(ck.name == "ch_cd"){		
			if(ck.checked == true){
				cnt++;
				idnum=ck.value;
			}
		}
	}	
	if(cnt == 0){
	 	alert("삭제할 자동차번호를 선택하세요.");
		return;
	}		
	if(confirm('선택한 번호를 삭제 하시겠습니까?')){	
		fm.action = 'delete_car_scrap.jsp';
		fm.target = 'i_no';
		fm.submit();
	}
}

//배정구분 일괄저장 버튼
function regAllCarNoStat(){
	var fm = document.form1;
	if(confirm('현재 배정구분 상태 그대로 일괄 저장 됩니다.\n\n현재 페이지에서는 배정구분이 신규 상태인 번호만 표시됩니다.\n\n저장 하시겠습니까?')){
	 	var fn = "save_car_no_stat";
		fm.target = 'i_no';
		fm.action='new_car_num_list_a.jsp?fn='+fn+'&param=2';
		fm.submit(); 
	} 
}
-->	
</script>
</head>
<body>
<form action="" name="form1" method="post">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="from_page" value="<%=from_page%>">
<input type="hidden" name="s_kd" value="<%=s_kd%>">
<input type="hidden" name="t_wd" value="<%=t_wd%>">
<input type="hidden" name="gubun" value="<%=gubun%>">
<input type="hidden" name="cmd" value="">
<input type="hidden" name="seq" value="">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr> 
    	<td>
		<table border="0" cellspacing="0" cellpadding="0" width=100%>
			<tr>
			    <td class=line2></td>
			</tr>
		    <tr> 
		        <td class='line'> 
		            <table  border=0 cellspacing=1 cellpadding="0" width=100%>
		            	<colgroup>
		            		<col width="3%;">
		            		<col width="3%;">
		            		<col width="6%;">
		            		<col width="6%;">
		            		<col width="7%;">            		
		            		<col width="7%;">
		            		<col width="7%;">
		            		<col width="5%;">
		            		<col width="7%;">
		            		<col width="5%;">
		            		<col width="10%;">
		            		<col width="6%;">            		
		            		<col width="12%;">
		            		<col width="9%;">
		            		<col width="7%;">
		            	</colgroup>
<%if(scrs.size() > 0){
	for(int i =0; i < scrs.size() ; i++){
		Hashtable scr = (Hashtable)scrs.elementAt(i);			
%>
		                <tr> 
		                    <td align="center"><a href="javascript:updateCar_scarp('<%=scr.get("SEQ")%>','<%=scr.get("CAR_NO")%>','<%=scr.get("CAR_NM")%>','<%=AddUtil.ChangeDate2((String)scr.get("REG_DT"))%>','<%=scr.get("CAR_EXT")%>');"><%=i+1%></a></td>
		                    <td align="center"><input type="checkbox" name="ch_cd" value="<%=scr.get("SEQ")%>"></td>
		                    <td align="center"><a href="javascript:car_no_history('<%=scr.get("CAR_NO")%>');"><%=scr.get("CAR_NO")%></a></td>
		                    <td align="center"><%=scr.get("CAR_EXT")%></td>
		                    <td align="center"><%=AddUtil.ChangeDate2((String)scr.get("INIT_REG_DT"))%></td>
		                    <td align="center"><%=AddUtil.ChangeDate2((String)scr.get("REG_DT"))%></td>
		                    <td align="center"><%=AddUtil.ChangeDate2((String)scr.get("END_DT"))%></td>
		                    <td align="center">
		                    	<input type="hidden" name="list_seq" value="<%=scr.get("SEQ")%>">
		                    	<select name="car_no_stat" id="car_no_stat">
		                    		<option value="" <%if(scr.get("CAR_NO_STAT").equals("")||scr.get("CAR_NO_STAT")==null){%>selected<%}%>></option>
		                    		<option value="2" <%if(scr.get("CAR_NO_STAT").equals("2")){%>selected<%}%>>대차</option>
		                    		<option value="3" <%if(scr.get("CAR_NO_STAT").equals("3")){%>selected<%}%>>대기</option>
		                    		<option value="4" <%if(scr.get("CAR_NO_STAT").equals("4")){%>selected<%}%>>반납</option>
		                    		<option value="5" <%if(scr.get("CAR_NO_STAT").equals("5")){%>selected<%}%>>말소</option>
		                    	</select>
		                    </td>
		                    <td align="center"><%=AddUtil.ChangeDate2((String)scr.get("UPD_DT"))%></td>
		                    <td align="center"><%=scr.get("AUTO_YN")%></td>
<%
		if(!scr.get("RENT_L_CD").equals("") && scr.get("RENT_L_CD") !=  null){
			Vector detailLists = sc_db.getNewCarNumDetailList((String)scr.get("RENT_L_CD"));
			if(detailLists.size() > 0){
				for(int j =0; j < detailLists.size() ; j++){
					Hashtable detailList = (Hashtable)detailLists.elementAt(j);
%>                    
		                    <td align="center"><%=detailList.get("RENT_L_CD")%></td>
		                    <td align="center"><%=detailList.get("REG_NM")%></td>
		                    <td align="center"><%=scr.get("CAR_NM")%></td>
		                    <td align="center"><%=detailList.get("CAR_NUM")%></td>
		                    <td align="center"><%=AddUtil.ChangeDate2((String)detailList.get("REG_DT"))%></td>
<% 				}
			}
		}else{		%>                
		                    <td align="center"></td>
		                    <td align="center"></td>
		                    <td align="center"><%=scr.get("CAR_NM")%></td>
		                    <td align="center"></td>
		                    <td align="center"></td>
<%		}
%>						</tr>	<%
	}
}else{%>
                 		<tr> 
                    		 <td colspan="15" align="center">등록된 자료가 없습니다.</td>
                		 </tr>
<%}%>
		            </table>
		        </td>
		    </tr>
		</table>
		</td>
	</tr>
</table>
</form>

<%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){ %>
<div align="right">
	<input type="button" class="button" value="배정구분 일괄저장" onclick="javascript:regAllCarNoStat();">
	&nbsp;&nbsp;&nbsp;<a href="javascript:deleteCar_scrap();"><img src=/acar/images/center/button_delete.gif align=absmiddle border=0></a>
</div>	
<%}%>
		    
<%-- <table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>		
        <td> 
            <table border="0" cellspacing="0" cellpadding="0" width=100%>
                <tr>					
                    <td class='line'> 
                        <table  border=0 cellspacing=1 width="100%">
                        <%if(scrs.size() > 0){
        					for(int i =0; i < scrs.size() ; i++){
        						Hashtable scr = (Hashtable)scrs.elementAt(i);%>
                            <tr> 
                                <td align="center" width="8%"><a href="javascript:updateCar_scarp('<%=scr.get("SEQ")%>','<%=scr.get("CAR_NO")%>','<%=scr.get("CAR_NM")%>','<%=AddUtil.ChangeDate2((String)scr.get("REG_DT"))%>','<%=scr.get("CAR_EXT")%>');"> <%=i+1%> </a></td>
            			<td  width='8%' align='center'><input type="checkbox" name="ch_cd" value="<%=scr.get("SEQ")%>"></td>
                                <td align="center" width="10%"><%=scr.get("CAR_EXT_NM")%></td>
                                <td align="center" width="15%"><a href="javascript:car_no_history('<%=scr.get("CAR_NO")%>');"><%=scr.get("CAR_NO")%></a></td>
                                <td align="center" width="44%"><%=scr.get("CAR_NM")%></td>
                                <td align="center" width="15%"><%=AddUtil.ChangeDate2((String)scr.get("REG_DT"))%></td>
                            </tr>
                            <% }
            				}else{%>
                            <tr> 
                                <td colspan="6" align="center">등록된 자료가 없습니다.</td>
                            </tr>
                            <%}%>
                        </table>
        		    </td>
        		</tr>
        		<tr>
        		    <td align=right>
        			  <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){ %>
        			  &nbsp;&nbsp;&nbsp;<a href="javascript:deleteCar_scrap();"><img src=/acar/images/center/button_delete.gif align=absmiddle border=0></a>
        			  <%}%>
        			</td>
                </tr>
    	    </table>
	    </td>
    </tr>	
</table> --%>

<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
