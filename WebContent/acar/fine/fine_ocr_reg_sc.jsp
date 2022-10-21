<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.client.*, acar.forfeit_mng.*, acar.user_mng.*, acar.common.*,java.net.URLEncoder "%>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String paid_no = request.getParameter("paid_no")==null?"":request.getParameter("paid_no");
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String seq 	= request.getParameter("seq")==null?"":request.getParameter("seq");
	String file_name 	= request.getParameter("file_name")==null?"":request.getParameter("file_name");
	String save_folder 	= request.getParameter("save_folder")==null?"":request.getParameter("save_folder");
	String yyyy = save_folder.substring(save_folder.length()-4, save_folder.length());
	String file_url = yyyy+"/"+file_name;
	
	String imgUrl = "https://ocr.amazoncar.co.kr:8443/fine_mng/"+yyyy+"/"+ URLEncoder.encode(file_name, "EUC-KR");
	
	ForfeitDatabase fdb = ForfeitDatabase.getInstance();
	
	FineOcrBean fib = fdb.getFineOcr(paid_no, car_no, seq);
	
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	
	//����� ����Ʈ
	CommonDataBase c_db = CommonDataBase.getInstance();
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
%>

<html>
<head><title>FMS</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
	var flag = "N";
	// ���·� �̹��� �˾�
	function fnImgPop(url) {
		var img = new Image();
		img.src = url;
		var img_width = 1000;
		var win_width = 1000;
		var img_height = img.height;
		var win = img.height + 30;
		var OpenWindow = window.open('', '_blank', 'width=' + img_width
				+ ', height=' + img_height + ', menubars=no, scrollbars=auto');
		OpenWindow.document.write("<style>body{margin:0px;}</style><img src='"+url+"' width='"+win_width+"'>");
	}
	
	//���·�û����� �˻��ϱ�
	function fine_gov_search(){
		var fm = document.form1;	
		window.open("../fine_doc_reg/fine_gov_search.jsp", "SEARCH_FINE_GOV", "left=200, top=200, width=900, height=450, scrollbars=yes");
		}
	
	// �ش� ���� ��ȣ �� ���� �Ͻ÷� ����� �˻� ajax
	function search_car() {
		var car_no_temp = $("#car_no").val();
		var car_no = car_no_temp.replace(/ /gi, ""); // ��������
		$("#car_no").val(car_no);
		var vio_dt = $("#vio_dt").val();
		var gov_id = $("#gov_id").val(); 
		
		if(!car_no) {
			alert("���� ��ȣ�� �Է��ϼ���.");
			return;
		} else if(!vio_dt) {
			alert("�����Ͻø� �Է��ϼ���.");
			return;
		}
		
		var dataJson = {"car_no" : car_no, "vio_dt" : vio_dt, "gov_id" : gov_id};
		$.ajax({
	        type : "POST",
	        url : './fine_car_search_ajax.jsp',
	        data : JSON.stringify(dataJson),
	        contentType: "application/json; charset=utf-8",
	        dataType : "json",
	        async : false,
	        success : function(data){
	        	if(data.result == "OK") {
	        		alert("�� �˻� �Ϸ�");
	        		// �����δ� �� ���� �ߺ� �� ����� ����(�׽�Ʈ)
// 	        		var SUBWIN="./fine_search_cont.jsp?car_no="+car_no+"&"+"vio_dt="+vio_dt.substring(0,10);	
// 	        		window.open(SUBWIN, "FineSearchCont", "left=10, top=10, width=1500, height=600, scrollbars=yes");
	        	} else if(data.result == "�� ���� �ߺ�") {
	        		alert("�ߺ��� �� ������ �����մϴ�. �˾����� ���� �� ������ �����ϼ���.");
	        		var SUBWIN="./fine_search_cont.jsp?car_no="+car_no+"&"+"vio_dt="+vio_dt.substring(0,10);	
	        		window.open(SUBWIN, "FineSearchCont", "left=10, top=10, width=1500, height=600, scrollbars=yes");
	        		return;
	        	} else if(data.result == "�� ���� ����") {
	        		alert("�� ������ �����ϴ�.");
	        		var SUBWIN="./fine_search_cont.jsp?car_no="+car_no+"&"+"vio_dt="+vio_dt.substring(0,10);	
	        		window.open(SUBWIN, "FineSearchCont", "left=10, top=10, width=1500, height=600, scrollbars=yes");
	        		return;
	        	} else if(data.result == "�̹� ��ϵ� ���·� ����") {
					alert("�̹� ��ϵ� ���·� ������ �־� ���·� ���ȭ������ �̵��մϴ�.");
	        		
	        		$("#car_mng_id").val(data.c_id);
		        	$("#rent_l_cd").val(data.l_cd);
		        	$("#rent_mng_id").val(data.m_id);
		        	$("#mng_id").val(data.mng_id);
		        	$("#mng_id2").val(data.mng_id);
		        	$("#rent_st").val(data.rent_st);
		        	$("#rent_s_cd").val(data.s_cd);
	        		
	        		// ���� ���·� �������� �̵� ���
	        		var fm = document.form1;
	        		fm.target = "d_content";
					fm.action = "../fine_mng/fine_mng_frame.jsp";
					fm.submit();
	        	}
	        	// ���� input �ڽ� �� �Ҵ�
	        	$("#car_mng_id").val(data.c_id);
	        	$("#rent_l_cd").val(data.l_cd);
	        	$("#rent_mng_id").val(data.m_id);
	        	$("#mng_id").val(data.mng_id);
	        	$("#mng_id2").val(data.mng_id);
	        	$("#rent_st").val(data.rent_st);
	        	$("#rent_s_cd").val(data.s_cd);
	        },
	        error : function(data){
	        	alert("error");
	        }
	    });
	}
	// ���·� ���
	function fine_reg() {
		if(confirm("���·� ������ ����Ͻðڽ��ϱ�?")) {
			var paid_no = $("#paid_no").val();
			var car_no =  $("#car_no").val();
			var gov_id =  $("#gov_id").val();
			var vio_dt = $("#vio_dt").val();
			var vio_pla = $("#vio_pla").val();
			var paid_amt = $("#paid_amt").val();
			var paid_amt2 = $("#paid_amt2").val();
			var obj_end_dt = $("#obj_end_dt").val();
			var paid_end_dt = $("#paid_end_dt").val();
			var c_id = $("#car_mng_id").val();
			var checkedYn = $('#email_yn').is(':checked');
			
			
			if(checkedYn) {
				$("#email_yn_val").val("Y");
			} else {
				$("#email_yn_val").val("N");
			}
			
			if(!car_no) {
				alert("���� ��ȣ�� �Է��ϼ���.");
				return;
			} else if(!gov_id) {
				alert("û�� ����� ��ȸ�ϼ���.");
				return;
			} else if(!vio_dt) {
				alert("���� �Ͻø� �Է��ϼ���.");
				return;
			} else if(!paid_amt) {
				alert("���� �ݾ��� �Է��ϼ���.");
				return;
			}else if(!paid_end_dt) {
				alert("���� ������ �Է��ϼ���.");
				return;
			} else if(!c_id) {
				alert("������ȣ�� ���� ��ȸ�ϼ���.");
				return;
			}
			
			var fm = document.form1;
			fm.target = 'i_no';
			fm.action = "./fine_ocr_reg_i_a.jsp";		
			fm.submit();
		} else {
			return;
		}
	}
	
	function notReg() {
		if(confirm("�ش� ���·� ������ �̵�� ó���Ͻðڽ��ϱ�?")) {
			// regYn ������Ʈ
			var fm = document.form1;
			fm.target = 'i_no';
			fm.action = "fine_ocr_notReg_i_a.jsp";		
			fm.submit();
		} else {
			return;
		}
	}
	
	// û����� �ű� ��� ����
	function gov_reg() {
		window.open("/acar/fine_gov/fine_gov_i.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>", "REG_FINE_GOV", "left=200, top=200, width=550, height=400, scrollbars=yes");
	}
	
	// �˾� ������(fine_search_cont)���� ȣ��
	function getContInfo(car_st, car_mng_id,rent_mng_id,rent_l_cd, rent_st, car_no, mng_id) {
    	$("#car_mng_id").val(car_mng_id);
    	$("#rent_mng_id").val(rent_mng_id);
    	$("#rent_l_cd").val(rent_l_cd);
    	$("#rent_st").val(rent_st);
    	$("#car_no").val(car_no);
    	$("#mng_id2").val(mng_id);
	}
	
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
<div  style="width: 30%;display: inline-block; height: 55%; position: fixed;">
	<div>
	<form name='form2' method='post' enctype="multipart/form-data" style="width:100%">
	<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
	<input type='hidden' name='user_id' value='<%=user_id%>'>
	<input type='hidden' name='br_id' value='<%=br_id%>'>
	<input type='hidden' name='size' value=''>
	
	</form>
	</div>
	
	<div style="margin-top: 40%;">
	<form name='form1' method='get' enctype="multipart/form-data" style="width:100%">
	<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
	<input type='hidden' name='user_id' value='<%=user_id%>'>
	<input type='hidden' name='br_id' value='<%=br_id%>'>
	<input type='hidden' name='size' value=''>
	<input type='hidden' name='gubun1' value='<%=gubun1%>'>
	<input type='hidden' name='st_dt' value='<%=st_dt%>'>
	<input type='hidden' name='end_dt' value='<%=end_dt%>'>
	<input type='hidden' name='seq' value='<%=seq%>'>
	<input type='hidden' name='c_id' id='car_mng_id' value=''>
	<input type='hidden' name='l_cd' id='rent_l_cd' value=''>
	<input type='hidden' name='m_id' id='rent_mng_id' value=''>
	<input type='hidden' name='mng_id' id='mng_id' value=''>
	<input type='hidden' name='rent_st' id='rent_st' value=''>
	<input type='hidden' name='rent_s_cd' id='rent_s_cd' value=''>
	<input type='hidden' name='seq_no' id='seq_no' value=''>
	<input type='hidden' name='temp_paid_no' id='temp_paid_no' value='<%=fib.getPaid_no()%>'>
	<input type='hidden' name='temp_vio_dt' id='temp_vio_dt' value='<%=fib.getVio_dt()%>'>
	<input type='hidden' name='file_url' id='file_url' value='<%=file_url%>'>
	
	  <table border="0" cellspacing="0" cellpadding="0" width=100%>
	    <td colspan="2"><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>���·� ���</span>
	    <input class="button btn-submit" type="button" value="�̵��" onclick="notReg()"></td>
	    <tr> 
	      <td class="line"> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
	          <tr> 
	            <td class='title'>����</td>
	            <td> 
	              &nbsp;&nbsp;
	              <select id="fine_st" name="fine_st" onchange="javascript:change_fine_st(this.value);" style="margin-left:-4px;">
                        <option value="1" selected>���·�</option>
                        <option value="2">��Ģ��</option>
                        <option value="3"> �ȳ���</option>
                  </select>
                  <input type="hidden" id="fine_gubun_type" name="fine_gubun_type" value="<%=fib.getGubun_type()%>"></input>
	            </td>
	          </tr>
	          <tr> 
	            <td class='title'>������ȣ</td>
	            <td> 
	              &nbsp;&nbsp;<input type="text" id="car_no" name="car_no" value="<%=fib.getCar_no()%>" size="20" class="text" style='IME-MODE: active'>
					<span class="b"><a id="carSearch" href="javascript:search_car()" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src="../images/center/button_in_search.gif" align="absmiddle" border="0"></a></span>
<!-- 				  <input type='hidden' name="gov_id" value="">			  -->
				</td>
	          </tr>
	          <tr> 
	            <td class='title'>û�����</td>
	            <td> 
	              &nbsp;&nbsp;
	              <input id="gov_nm" name="gov_nm" type="text" class=text size="30" maxlength="50" style='IME-MODE: active; margin-left: -4px' onKeyDown='javascript:enter()' onBlur='javascript:gov_set()'> 
        			  <input type='hidden' name="mng_dept" value=''>
        			  <input type='hidden' name="gov_st" value=''>
        			  <input type='hidden' name="mng_nm" value=''>
        			  <input type='hidden' name="mng_pos" value=''>
        			  <input type='hidden' id="gov_id" name="gov_id" value=''>
                      <a href="javascript:fine_gov_search();" onMouseOver="window.status=''; return true"><img src=../images/center/button_in_search1.gif align=absmiddle border=0></a>
	              	  <a href='javascript:gov_reg()' onMouseOver="window.status=''; return true">[û��������]</a><br>
	              </td>
	          </tr>
	          <tr> 
	            <td class='title'>�����Ͻ�</td>
	            <td> 
	              &nbsp;&nbsp;<input type="text" id="vio_dt" name="vio_dt" size="50" class="text" value="<%=fib.getVio_dt_2()%>"> 
	              </td>
	          </tr>
	          <tr> 
	            <td class='title'>�������</td>
	            <td>&nbsp;&nbsp;<input type="text" id="vio_pla" name="vio_pla" size="50" class="text" value="<%=fib.getVio_pla()%>"></td>
	          </tr>
	          <tr> 
	            <td class='title'>���ݳ���</td>
	            <td>&nbsp;&nbsp;
	            <select id="vio_st" name="vio_st" style="margin-left:-4px;">
                    	<option value="">����</option>
                        <option value="1">���α����</option>
                        <option value="2">���ᵵ�ι�</option>
                        <option value="3">�������</option>
                        <option value="4">�����������������</option>
                        <option value="5">��⹰������</option>
                      </select>
                      &nbsp;
	            <input type="text" id="vio_cont" name="vio_cont" size="20" class="text" value="<%=fib.getVio_cont()%>"></td>
	          </tr>
	          <tr> 
	            <td class='title'>���αݾ�</td>
	            <td> &nbsp;&nbsp;
                      <input type="text" id="paid_amt" name="paid_amt" value="<%=Util.parseDecimal(fib.getPaid_amt())%>" size="10" maxlength=8 class=num onBlur="javascript:this.value=parseDecimal(this.value)" style="margin-left:-4px;">
                      ��
<!-- 					  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;���ǳ��αݾ� -->
<!-- 					  <input type="text" id="paid_amt2" name="paid_amt2" value="" size="10" maxlength=8 class=num onBlur="javascript:this.value=parseDecimal(this.value);miss_write();"> -->
<!--                       �� -->
					  </td>
	          </tr>
	          <tr> 
	            <td class='title'>�ǰ���������</td>
	            <td>&nbsp;&nbsp;<input type="text" id="obj_end_dt" name="obj_end_dt" size="20" class="text" value="<%=fib.getObj_end_dt_2()%>">&nbsp;����</td>
	          </tr>
	          <tr> 
	            <td class='title'>���α���</td>
	            <td>&nbsp;&nbsp;<input type="text" id="paid_end_dt" name="paid_end_dt" size="20" class="text" value="<%=fib.getPaid_end_dt_2()%>">&nbsp;����</td>
	          </tr>
	          <tr> 
	            <td class='title'>���Ϲ߼ۿ���</td>
	            <td>&nbsp;&nbsp;<input type="checkbox" id="email_yn" name="email_yn" checked="checked">
	            				<input type="hidden" id="email_yn_val" name="email_yn_val"</td>
	          </tr>
	        </table>
	      </td>
	    </tr>
	    <tr>
	        <td align="right"><a href='javascript:fine_reg()' onMouseOver="window.status=''; return true"><img src="../images/center/button_reg.gif" align="absmiddle" border="0"></a></td>
	    </tr>
		<script language='javascript'>
		<!--	
	<%-- 		document.form1.size.value = <%=settle_size%>; --%>
		//-->
		</script>
	  </table>
	</form>
	</div>
</div>
<div style="width: 60%; display: inline-block; float: right;">
<!-- <form name='form2' method='post' enctype="multipart/form-data" style="width:100%"> -->
  <table border="0" cellspacing="0" cellpadding="0" width=100%>
  	<a  onMouseOver="window.status=''; return true"><img id="fine_img" src="<%=imgUrl%>" align="center" border="0" style="height: 140%;width: 100%;" onclick="fnImgPop(this.src)"></a>
  </table>
<!-- </form> -->
</div>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
</body>
</html>
