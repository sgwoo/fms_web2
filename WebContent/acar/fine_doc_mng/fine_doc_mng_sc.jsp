<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.forfeit_mng.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase" />
<%@ include file="/acar/cookies.jsp" %>

<%
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"3":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"1":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int cnt = 6; //��Ȳ ��� ������ �Ѽ�
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height);//��Ȳ ���μ���ŭ ���� ���������� ������
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+"&st_dt="+st_dt+"&end_dt="+end_dt+
				   	"&s_kd="+s_kd+"&t_wd="+t_wd+"&sort="+sort+"&asc="+asc+"&sh_height="+height+"";
%>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table_ts.css">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
</head>
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//���±� ���γ��� ����
	function view_fine_doc(doc_id){
		var fm = document.form1;
		fm.doc_id.value = doc_id;
		fm.target = "d_content";
		fm.action = "fine_doc_mng_c.jsp";
		fm.submit();
	}
	
	//���ű�� ���� 
	function view_fine_gov(gov_id){
		window.open("../fine_doc_reg/fine_gov_c.jsp?gov_id="+gov_id, "view_FINE_GOV", "left=200, top=200, width=600, height=250, scrollbars=yes");
	}
	
	//���ǽ�û�� �Ѱ� ���
	function ObjectionPrint(doc_id){
		var fm = document.form1;
		var SUMWIN = "";
		SUMWIN="objection_print.jsp?doc_id="+doc_id;	
		window.open(SUMWIN, "ObjectionPrint", "left=50, top=50, width=750, height=800, scrollbars=yes, status=yes");			
	}
	
	//���� �Ѱ� ����ϱ�
	function FineDocPrint(doc_id){
		var fm = document.form1;
		var SUMWIN = "";
		SUMWIN="fine_doc_print.jsp?doc_id="+doc_id;	
		window.open(SUMWIN, "DocPrint", "left=50, top=50, width=750, height=800, scrollbars=yes, status=yes");			
	}
	
		
	//�󺧽�ƼĿ���	
	function select_label(){
		var fm = inner.document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_l_cd"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}	
		if(cnt == 0){
		 	alert("�� �μ��� ������ �����ϼ���.");
			return;
		}	
		alert('�󺧿��� ������ ���� ���� Ȯ���Ͽ� ���� ���� ��ŭ üũ�Ͽ� �μ��Ͻñ� �ٶ��ϴ�.');
		fm.doc_cnt.value = cnt;
		fm.target = "_blank";
		fm.action = "label_print_select.jsp?";
		fm.submit();	
		
	}			
	
	//�����ϰ��μ�
	function select_out(no){
		var fm = inner.document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var item_cnt=0;
		var idnum="";
		var max_cnt = 20;

	    // jjlim@20171116 �����ε� �÷���
	    var isLazyLoading = document.getElementById('lazy-loading').checked;
	
	    for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];
			if(ck.name == "ch_l_cd"){
				if(ck.checked == true){
					cnt++;
					if(fm.fee_size.value == '1'){
						idnum=fm.ch_cnt.value;
					}else{
						idnum=fm.ch_cnt[ck.value].value;
					}
					
					item_cnt = item_cnt + toInt(idnum);	
					/* if(no=='1'){ 
						if(isLazyLoading == false && item_cnt > max_cnt){
							ck.checked = false;
						}
					} */
				}
			}
		}
		
		/* if(no=='1'){
			if(isLazyLoading == false && item_cnt > max_cnt){
				alert('�Ǽ����� �ִ� '+max_cnt+'�Ǳ��� �Դϴ�.');
				cnt = 0;
				idnum="";
				for(var i=0 ; i<len ; i++){
					var ck=fm.elements[i];
					if(ck.name == "ch_l_cd"){
						if(ck.checked == true){
							cnt++;
							idnum=ck.value;
						}
					}
				}
				return;
			}
		} */
		
		if(cnt == 0){
		 	alert("�μ��� ������ �����ϼ���.");
			return;
		}
		
		//�ѰǾ� �˾�����
    	<%-- for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];
			if(ck.name == "ch_l_cd"){
				if(ck.checked == true){
	            	var ch_l_cd =fm.ch_l_cd[ck.value].value;
	            	var ch_doc_id =fm.ch_doc_id[ck.value].value;
	            	var ch_cnt =fm.ch_cnt[ck.value].value;
	            	
	            	if(no=='1'){ //����+��༭+�ź��� �μ�
	                    if (isLazyLoading) {
	                    	var url = "/acar/fine_doc_mng/fine_doc_print_select_low.jsp?user_id=<%=user_id%>&find_type=popOne&ch_l_cd="+ch_l_cd+"&ch_doc_id="+ch_doc_id+"&ch_cnt="+ch_cnt;
			            	window.open(url, "PRINT_"+i , "left=100, top=100, width=1100, height=800, scrollbars=yes");
	                    }else {
			            	var url = "/acar/fine_doc_mng/fine_doc_print_select.jsp?user_id=<%=user_id%>&find_type=popOne&ch_l_cd="+ch_l_cd+"&ch_doc_id="+ch_doc_id+"&ch_cnt="+ch_cnt;
			            	window.open(url, "PRINT_"+i , "left=100, top=100, width=1100, height=800, scrollbars=yes");
	                    }
	        		}else if(no=='2'){ //�������μ�
	        			var url = "/acar/fine_doc_mng/fine_doc_print_select2.jsp?user_id=<%=user_id%>&find_type=popOne&ch_l_cd="+ch_l_cd+"&ch_doc_id="+ch_doc_id+"&ch_cnt="+ch_cnt;
	        			window.open(url, "PRINT_"+i , "left=100, top=100, width=1100, height=800, scrollbars=yes");
	        		}else if(no=='3'){ //JPG��ĵȮ��
	        			fm.action = "fine_doc_print_select3.jsp?";
	        		} 
				}
			}
    	} --%>
    	
    	//���� - �������� ���ǿ���
		if(no=='1'){ //����+��༭+�ź��� �μ�
            if (isLazyLoading) {
                fm.action = "fine_doc_print_select_low.jsp?";
            }else {
                fm.action = "fine_doc_print_select.jsp?";
            }
		}else if(no=='2'){ //�������μ�
			fm.action = "fine_doc_print_select2.jsp?";
		}else if(no=='3'){ //JPG��ĵȮ��
			fm.action = "fine_doc_print_select3.jsp?";
		} 
		
		//if((no=='1' && !isLazyLoading) || (no=='1' && isLazyLoading) || no=='2'){}
		//else{	
			fm.doc_cnt.value = cnt;
			fm.target = "_blank";
			fm.submit();
		//}	
	}
	
	//ó������ �ϰ�����(20180726)
	function save_complete_etc(){
		var fm = inner.document.form1;
		var fm2 = document.form1;
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		var compl_etc = $("#compl_etc option:selected").val();
		
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_l_cd"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}	
		if(cnt == 0){
		 	alert("ó�������� ������ ������ �����ϼ���.");
			return;
		}
		fm.doc_cnt.value = cnt;
		fm.target = "_blank";
		fm.action = "fine_doc_mng_u_a.jsp?mode=compl_etc_u&compl_etc="+compl_etc;
		fm.submit();
	}
	
//-->
</script>
<body>
<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='doc_id' value=''>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort' value='<%=sort%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
      <td>
				<!--�ϰ��μ�-->
        * �������� : 
        <select name='doc_print_st' onChange="javascript:inner.doc_check_set()"> 
		      <option value="">����</option>
		    </select>
	      &nbsp;	
		    ��Ÿ���� : 
		    <input type="text" name="d_start_num" size="2" class="text" value="">~<input type="text" name="d_end_num" size="2" class="text" value="">
		    &nbsp;
		    <a href="javascript:inner.doc_check_set();" title="��ĵ���� �����μ�">[����]</a>
				&nbsp;&nbsp;
      	<a href="javascript:select_out('1');" title="�������"><img src="/acar/images/center/button_print_all.gif" align="absmiddle" border="0"></a>&nbsp;(��� �ִ�20��)&nbsp;&nbsp;

		  	<%-- jjlim@20171116 �����ε� --%>
		  	<input type="checkbox" name="lazy-loading" id="lazy-loading">�����&nbsp;&nbsp;
	
				<!--������ �μ�-->
				<a href="javascript:select_out('2');" title="���������">[���������]</a>&nbsp;&nbsp;

				<!--�󺧽�ƼĿ���-->
				<a href="javascript:select_label();" title="�����"><img src="/acar/images/center/button_print_label.gif" align="absmiddle" border="0"></a>&nbsp;&nbsp;
			
			<%
				Vector fines = FineDocDb.getFineDocLists("����", br_id, gubun1, gubun2, gubun3, gubun4, "", st_dt, end_dt, s_kd, t_wd, sort, asc);
				int fine_size = fines.size();
				int total_cnt = 0;
        		for(int i = 0 ; i < fine_size ; i++){
			      	Hashtable ht = (Hashtable)fines.elementAt(i);
			      	total_cnt += Integer.parseInt(String.valueOf(ht.get("CNT")));
        		}
			%>
        		&nbsp;&nbsp;&nbsp;&nbsp;( �� <%=total_cnt%> �� )
      </td>
      <td align="right">
      	<select name="compl_etc" id="compl_etc">
      		<option value="1">����24</option>
      		<option value="2">�μ�</option>
      		<option value="3">FAX</option>
      		<option value="4">Ȩ���������</option>
      	</select>
      	<input type="button" class="button" value="ó������" onclick="javascript:save_complete_etc();">
	  </td>   	
    </tr>  
  <tr>
	<td colspan="2">
      <table border="0" cellspacing="0" cellpadding="0" width=100%>
		<tr>
		  <td width=100%>
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
			  <tr>
				<td align='center'>
				  	<iframe src="fine_doc_mng_sc_in.jsp<%=valus%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe>
				</td>
			  </tr>
			</table>
		  </td>
		</tr>
	  </table>
    </td>
  </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
