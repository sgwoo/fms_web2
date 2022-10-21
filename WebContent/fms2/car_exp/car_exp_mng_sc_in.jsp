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
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	Vector fines = FineDocDb.getFineDocLists("환급", br_id, gubun1, gubun2, gubun3, gubun4, "", st_dt, end_dt, s_kd, t_wd, sort, asc);
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
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<table border="0" cellspacing="0" cellpadding="0" width='100%'>
	<tr><td class=line2 colspan=2></td></tr>
    <tr id='tr_title' style='position:relative;z-index:1'>
	    <td class='line' width='51%' id='td_title' style='position:relative;'>			
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
	    <td class='line' width='49%'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td class='title' width="15%">건수</td>
                    <td class='title' width="20%">인쇄일자</td>
                    <td class='title' width="15%">공문</td>
                    <td class='title' width="15%">등록자</td>
                    <td class='title' width="20%">등록일</td>						
                </tr>
            </table>
	    </td>
    </tr> 
    <tr>
    	<td class='line' width='51%' id='td_con' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
              <%for(int i = 0 ; i < fine_size ; i++){
    				Hashtable ht = (Hashtable)fines.elementAt(i);%>
                <tr> 
					<td  align='center' width="8%"><input type="checkbox" name="ch_l_cd" value="<%=ht.get("DOC_ID")%><%=ht.get("CNT")%>"></td>
                    <td  align='center' width="8%"><%=i+1%></td>
                    <td  width='21%' align='center'><a href="javascript:parent.view_fine_doc('<%=ht.get("DOC_ID")%>')" onMouseOver="window.status=''; return true"><%=ht.get("DOC_ID")%></a></td>
                    <td  width='21%' align='center'><%=AddUtil.getDate3(String.valueOf(ht.get("DOC_DT")))%></td>
                    <td  width='42%' align='center'><a href="javascript:parent.view_fine_gov('<%=ht.get("GOV_ID")%>');"><%=Util.subData(String.valueOf(ht.get("GOV_NM")), 12)%></a></td>
                </tr>
              <%}%>
    		  <%if(fine_size==0){%>
                    <td  align='center'>등록된 데이타가 없습니다.</td>		  
              <%}%>		  
            </table>
    	</td>
    	<td class='line' width='49%'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
              <%for(int i = 0 ; i < fine_size ; i++){
    				Hashtable ht = (Hashtable)fines.elementAt(i);%>
                <tr> 
                    <td align="center" width="15%"><%=ht.get("CNT")%>건</td>
                    <td align="center" width="20%"><span title="<%=c_db.getNameById(String.valueOf(ht.get("PRINT_ID")), "USER")%>"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("PRINT_DT")))%></span></td>
                    <td  width='15%' align='center'><%if(!nm_db.getWorkAuthUser("아마존카이외",user_id)){%><a href="javascript:parent.FineDocPrint('<%=ht.get("DOC_ID")%>');"><img src=/acar/images/center/button_in_print.gif align=absmiddle border=0></a><%}%></td>
                    <td align="center" width="15%"><%=c_db.getNameById(String.valueOf(ht.get("REG_ID")), "USER")%></td>			
                    <td align="center" width="20%"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%></td>						
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
	<!--
    <tr>
      <td colspan=2>
        * 묶음선택 : 
        <select name='doc_print_st' onChange="javascript:doc_check_set()"> 
		  <option value="">선택</option>                       
		<%	int max_num = 10;
			for(int i=0; i<fine_size; i+=max_num){
				int start_num 	= i+1;
				int end_num 	= i+max_num;
				if(end_num>fine_size) end_num = fine_size;  %>
		  <option value="<%=start_num%>~<%=end_num%>"><%=start_num%>~<%=end_num%></option>
		<%	}%>	
		</select>
	  &nbsp;	
		기타선택 : 
		<input type="text" name="d_start_num" size="2" class="text" value="">~<input type="text" name="d_end_num" size="2" class="text" value="">
		&nbsp;
		<a href="javascript:doc_check_set();" title="스캔파일 분할인쇄">[선택]</a>	
	</td>
    </tr>
	-->
</table>
<input type='hidden' name='sub_size' value='<%=sub_size%>'>
</form>
<script language='javascript'>
<!--
	function doc_check_set(){
		var fm = document.form1;
		
		var start_num 	= 0;
		var end_num 	= 0;
		
		if(fm.doc_print_st.value == '' && toInt(fm.d_start_num.value) >0){
			start_num 	= toInt(fm.d_start_num.value);
			end_num 	= toInt(fm.d_end_num.value);			
		}else{ 						
			var select_nums = fm.doc_print_st.value.split("~");				
			start_num 	= toInt(select_nums[0]);
			end_num 	= toInt(select_nums[1]);
		}
		
		if(start_num >0 && end_num>0){
			//초기화
			var len = fm.elements.length;
			for(var i=0; i<len; i++){
				var ck = fm.elements[i];
				if(ck.checked == true){
					ck.click();
				}
			}
				
			//선택별 처리
			for(var i=start_num-1 ; i<=end_num ; i++){
				fm.ch_l_cd[i].checked = true;
			}
		}
	}
//-->
</script>
</body>
</html>
