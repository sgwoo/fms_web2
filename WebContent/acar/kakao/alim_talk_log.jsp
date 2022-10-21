<%@ page contentType="text/html; charset=euc-kr" language="java" %>

<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
    // �Ķ����
    String templateCode = request.getParameter("t_cd")==null? "":request.getParameter("t_cd");
    String rentMngId = request.getParameter("mng_id")==null? "":request.getParameter("mng_id");
    String rentLCode = request.getParameter("l_cd")==null? "":request.getParameter("l_cd");
    
    
     String searchType = request.getParameter("s_type")==null? "":request.getParameter("s_type");

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
    <title>FMS</title>
    <link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>


    <style type="text/css">
        .table-style-1 {
            font-family:����, Gulim, AppleGothic, Seoul, Arial;
            font-size: 9pt;
            color: #515150;
            font-weight: bold;
        }
        .table-back-1 {
            background-color: #B0BAEC
        }
        .one-line {
            text-overflow: ellipsis;
            white-space: nowrap !important;
            overflow: hidden;
        }
    </style>

    <script language='JavaScript' src='/include/common.js'></script>
    <script language="JavaScript" type="text/JavaScript">

        var templateCode = '<%= templateCode %>';
        var rentMngId = '<%= rentMngId %>';
        var rentLCode = '<%= rentLCode %>';
        
        var searchType = '<%= searchType %>';   //��࿡�� ������ �α� ��ȸ�ΰ��  
        

        $(document).ready(function(){
        	
        	$('#select-first-category').val("0");
        	$('#select-category').val("0");        	
         	$('#select-category').hide();

			//�������� ó�� 
			$('#s_dt').bind('change', function() {
            
				var option = $(this).find('option:selected');            
             
        		if (option.val() == '6') {        			
            	   $("#t_st_dt").show(); 
                	$("#t_ed_dt").show();     
             	} else {
                	$("#t_st_dt").hide(); 
                	$("#t_ed_dt").hide();         
            	 }
			});
		     
		    $('#s_dt').trigger('change');                     
            
            // ���ø� ī�װ� ���ý� : ���ø� ����Ʈ ������
            $('#select-first-category').bind('change', function() {
            
              	var option = $(this).find('option:selected');
            
             	// �����Է� - ģ���� Ȯ�� 
        		if (option.val() == '10') {
        			
        			$('#select-category').empty();
	                var html =
	                    '<option value="0" selected>ī�װ�����</option>';
	                $('#select-category').append(html);
	            	
	            	$('#select-category').val("0");
        			
            		$('#template-select').empty();
            		$('#template-select').append('<option value="10" selected>���ø� ����</option>');
             	}
		        // ���ø� �Է�
		        else {
		        	
		        	if (option.val() == '0') {
		            	
		            	$('#select-category').empty();
		                var html =
		                    '<option value="0" selected>ī�װ�����</option>';
		                $('#select-category').append(html);
		            	
		                $('#select-category').val("0");        	
		            	$('#select-category').hide();
		            	$('#template-select').show();
		            	
		            } else if (option.val() == '1') {
		            	
		            	$('#select-category').empty();
		                var html =
		                    '<option value="0" selected>ī�װ�����</option>'+
		                    '<option value="1" selected>���뿩</option>'+
		                    '<option value="2" selected>����Ʈ</option>'+
		                    '<option value="3" selected>���¾�ü</option>'+
		                    '<option value="4" selected>���ݾȳ�</option>';
		                $('#select-category').append(html);
		                
		            	$('#select-category').val("0");
		            	$('#select-category').show();
		            	$('#template-select').show();
		                
		            } else if (option.val() == '2') {
		            	
		            	$('#select-category').empty();
		                var html =
		                    '<option value="0" selected>ī�װ�����</option>'+
		                    '<option value="5" selected>�뿩����</option>'+
		                    '<option value="6" selected>����ȳ�</option>'+
		                    '<option value="7" selected>�������</option>'+
		                    '<option value="8" selected>�����ȳ�</option>'+
		                    '<option value="9" selected>�������</option>'+
		                    '<option value="10" selected>����ȳ�</option>'+
		                    '<option value="11" selected>�������</option>'+
		                    '<option value="12" selected>����ȳ�</option>'+
		                    '<option value="13" selected>����˻�</option>'+
		                    '<option value="14" selected>��ü�ȳ�</option>'+
		                    '<option value="15" selected>Ź��</option>';
		                $('#select-category').append(html);
		                
		            	$('#select-category').val("0");
		            	$('#select-category').show();
		            	$('#template-select').show();
		            	
		            } else {
		            	
		            	$('#select-category').empty();
		                var html =
		                    '<option value="0" selected>ī�װ�����</option>';
		                $('#select-category').append(html);
		            	
		            	$('#select-category').val("0");
		            	$('#select-category').show();
		            	$('#template-select').show();
		            }
		        	
		            ajaxGetTemplateList($(this).val(), $('#select-category').val());
		        }
		     });
            
            $('#select-category').bind('change', function() {
            
              	var option = $(this).find('option:selected');
            
             	// �����Է� - ģ���� Ȯ�� 
        		if (option.val() == '10') {
        			
            		$('#template-select').empty();
            		$('#template-select').append('<option value="10" selected>���ø� ����</option>');
             	}
		        // ���ø� �Է�
		        else {
		            ajaxGetTemplateList($('#select-first-category').val(), $(this).val());
		        }
		     });
    
            $('#select-category').trigger('change');

            // �˻���ư
            $('#search-log-button').bind('click', function() {
                apiGetAlimTalkLog();
            });
            
        });
        
        function ajaxGetTemplateList(category_1, category) {
            var data = {
                cat_1: category_1,
            	cat: category,
            };
            var s_dt = $('select[name=s_dt] option:selected').val();
            
            $.ajax({
                cache: false,
                type: 'GET',
                url: './alim_template_ajax.jsp',
                dataType: 'json',
                data: {
                    cmd: 'log_list_only',
                    data: JSON.stringify(data)
                },
                success: function(data) {
                    setTemplateList(category, data);

                    // ���ø� �ڵ尡 ���� �ڵ� ����
                    if (templateCode != '') {
                        $('#template-select').val(templateCode);

                        // jjlim@20171121 ����ȣ �ڵ����� �߰�
                        if (rentLCode != '') {
                            $('select[name=s_kd]').val(1);
                            $('input[name=t_wd]').val(rentLCode);
                        }
                        
                        if (searchType != '') {
                            $('select[name=s_dt]').val(7);                                   
                        }
                     						
                        apiGetAlimTalkLog();
                        templateCode = '';
                    }
                },
                error: function(e) {
                    alert('���ø� ����Ʈ�� �������� ���߽��ϴ�');
                }
            });
        }

        function setTemplateList(cat, data) {
            $('#template-select').empty();
            $('#template-select').append('<option value="0" selected>���ø� ����</option>');
            data.forEach(function(tpl) {
                html =
                    '<option value="'+ tpl.CODE +'" ' +
                    'data-content="'+ tpl.CONTENT +'" '+
                    '>'+ tpl.NAME +'</option>';
                $('#template-select').append(html);
            });
        }

        function apiGetAlimTalkLog() {
            var category = $('#template-select option:selected').val();

            var s_dt = $('select[name=s_dt] option:selected').val();
            var t_st_dt = $('select[name=t_st_dt] option:selected').val();
            var t_ed_dt = $('select[name=t_ed_dt] option:selected').val();
            var s_kd = $('select[name=s_kd] option:selected').val();
            var t_wd = $('input[name=t_wd]').val();
 		
            if ( s_dt == '7' && t_wd == '' ) {
            	alert('�ֱ� 6������ �˻�� �ʼ��Դϴ�.');
            	return;
            }

            var data = {
                cat: category,
                s_dt: s_dt,
                t_st_dt: t_st_dt,
                t_ed_dt: t_ed_dt,
                s_kd: s_kd,
                t_wd: encodeURIComponent(t_wd)
            };
            
            $.ajax({
                 cache: false,
                type: 'GET',
                url: './alim_talk_ajax.jsp',
                dataType: 'json',
                data: {
                    cmd: 'alimtalk_log',
                    data: JSON.stringify(data)
                },
                success: function(data) {                  
                    setAlimTalkLog(data);
                },
                error: function(e) {
                    alert('�˸��� �α׸� �������� ���߽��ϴ�');
                }
            });
        }

        function setAlimTalkLog(data) {            
          
            var area = $('#log-table');

            area.find('tr[name="log-result"]').remove();

            var html = '';
            if (data.length == 0) {
                html = '<tr name="log-result" align="center"><td colspan="8">�˻��� �����Ͱ� �����ϴ�</td></tr>';
                $('#contract-result-count').html('0');
            } else {
            	data.forEach(function(elem, index) {
                    html +=
                        '<tr name="log-result" align="center">' +
                        '<td align="center">' + (index + 1) + '</td>' +
                        '<td>' + elem.DATE_CLIENT_REQ + '</td>' +
                        '<td>' + elem.TEMPLATE_CODE + '</td>';
                    if (elem.USER_NM == null || elem.USER_NM == "") {
                        html += '<td>' + elem.CALLBACK + '</td>';
                    } else {
                        html += '<td>' + elem.USER_NM + " (" + elem.CALLBACK + ')</td>';
                    }
                    html +=
                        '<td>' + elem.RECIPIENT_NUM + '</td>' +
                        '<td>' + elem.FIRM_NM + '</td>' +
                        '<td name="log-content" class="one-line" style="white-space: pre-line; text-align: left">' + elem.CONTENT+ '</td>' +
                        '<td>' + parseResultCode(elem.REPORT_CODE) + '</td>' +
                        '</tr>';
                });
            }
            area.append(html);

            area.find('tr[name="log-result"]').bind('click', function() {

                var contents = area.find('td[name="log-content"]');

                var aaa = contents.eq($(this).index() - 2);
                if (aaa.hasClass('one-line')) {
                    contents.addClass('one-line');
                    aaa.removeClass('one-line');
                } else {
                    contents.addClass('one-line');
                }

            });
        }

        function parseResultCode(code) {
            if (code == '1000') {
                return '����';
            } else {
                return '����(' + code + ")";
            }
        }

    </script>
</head>

<body leftmargin="15">

<%-- ��� --%>
<div>
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td colspan=10>
                <table width=100% border=0 cellpadding=0 cellspacing=0>
                    <tr>
                        <td width=7>
                        	<img src=/acar/images/center/menu_bar_1.gif width=7 height=33>
                        </td>
                        <td class=bar>
                        	&nbsp;&nbsp;&nbsp;
                        	<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>
                        	&nbsp;
                        	<span class=style1>
                        		FMS����� > SMS �� �̸��� > <span class=style5>�˸���߼۰���</span>
                        	</span>
                        </td>
                        <td width=7>
                        	<img src=/acar/images/center/menu_bar_2.gif width=7 height=33>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
        	<td class=h></td>
        </tr>
    </table>
</div>

<br>
<%-- �ȳ��� �߼� --%>
<div>
    <div class="table-style-1">
    	<img src=/acar/images/center/icon_arrow.gif align=absmiddle style="margin-right: 5px">
   		��� �˻�<img id="contract-search-loader" src=/acar/images/ajax-loader.gif align="absmiddle" style="margin: 2px; display: none">
   	</div>
    <table class="table-back-1" border="0" cellspacing="1" cellpadding="0" width="1200" style="margin-top: 3px">
        <tr>
        	<td class=line2 colspan=2></td>
        </tr>
        <tr>
            <td class="title" width=10%>���ø�</td>
            <td width="45%">&nbsp;
                <!-- <select id="select-category">
                    <option value="0">��ü</option>
                    <option value="1">��������</option>
                    <option value="2">��������</option>
                    <option value="3">���׺���</option>
                    <option value="5">ä�ǰ���</option>
                    <option value="7">���¾�ü����</option>
                    <option value="9">����</option>
                    <option value="10">�����Է�</option>
                </select> -->
                <select id="select-first-category">
		    		<option value="0">��ü</option>
		    		<option value="1">��ǰ��</option>
		    		<option value="2">���뺰</option>    		
		    		<option value="10">�����Է�</option> 		
		    	</select>
		        <select id="select-category" style="margin-left: 10px;">
		        	<option value="0">ī�װ�����</option>
		        </select>
                <select id="template-select" style="margin-left: 10px;">
                    <option value="0" selected>���ø� ����</option>
                </select>
            </td>
        </tr>
        <tr>
            <td class="title" width=10%>��ȸ����</td>
            <td width="45%">&nbsp;
                <select id="s_dt" name="s_dt">
                    <option value="1" selected>����</option>
                    <option value="2">����</option>
                    <option value="3">2��</option>
                    <option value="4">���</option>
                    <option value="5">����</option>
                    <option value="6">����</option>
         		<% if ( searchType.equals("log") ) {%>           
                    <option value="7">�ֱ�2����</option>
          		<% }%>                    
                </select>
                &nbsp;                
                <select id="t_st_dt" name="t_st_dt">
	  			<%for(int i=2017; i<=AddUtil.getDate2(1); i++){%>
					<option value="<%=i%>" <%if(AddUtil.getDate(1).equals(Integer.toString(i))){%>selected<%}%>><%=i%>��</option>
				<%}%>
				</select>
       			<select id="t_ed_dt" name="t_ed_dt">
       			<%for(int i=1; i<=12; i++){%>
       				<option value="<%=AddUtil.addZero2(i)%>" <%if(AddUtil.getDate(2).equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>��</option>
       			<%}%>
       			</select>  
            </td>
        </tr>
        <tr>
            <td class=title width=10%>�˻�����</td>
            <td width=40%>&nbsp;
                <select name='s_kd'>
                    <option value='1' >����ȣ</option>
                    <option value='6' >��ȣ</option>
                    <option value='2' >�߽���</option>
                    <option value='3' >�߽Ź�ȣ</option>
                    <option value='4' >���Ź�ȣ</option>
                    <option value='5' >����</option>                    
                </select>
                &nbsp;
                <input type='text' name='t_wd' size='18' class='text' value='' style='IME-MODE: active'>
            </td>
        </tr>
    </table>
    <div style="text-align: right; margin-top: 5px; width: 1200px;">
        <img id="search-log-button" src=/acar/images/center/button_search.gif align=absmiddle border=0 style="cursor: pointer;">
    </div>
    <br>
    <table id="log-table" class="table-back-1" border="0" cellspacing="1" cellpadding="0" width="1200" style="margin-top: 8px; table-layout: fixed">
    	<colgroup>
            <col width="5%">
            <col width="11%">
            <col width="6%">
            <col width="13%">
            <col width="10%">
            <col width="12%">
            <col width="37%">
            <col width="6%">
        </colgroup>
        <tr>
        	<td class=line2 colspan=2></td>
        </tr>
        <tr>
            <td class="title" >����</td>
            <td class="title" >�Ͻ�</td>
            <td class="title" >�ڵ�</td>
            <td class="title" >�߼���</td>
            <td class="title" >������</td>
            <td class="title" >��ȣ</td>
            <td class="title" >����</td>
            <td class="title" >���<a href="javascript:openPopF('application/pdf','8438378');" title='����ڵ� ����' ><img src="/acar/images/center/icon_pdf.gif" align=absmiddle border="0"></a></td>
        </tr>
        <tr name="log-result" align="center">
            <td colspan="8">�˻��� �̷��� �����ϴ�</td>
        </tr>
    </table>
</div>

</body>
</html>
