<%@ page language="java" contentType="text/html;charset=euc-kr"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
	var checkflag = "true";
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

-->
</script>
</head>

<body>
<table width="600" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td>
            <table width="580" border="0" cellspacing="0" cellpadding="0">
                <tr>    
                    <td class=line2></td>
                </tr>
                <tr> 
                    <td width="580" colspan="2" class="line">
                        <table width="100%" border="0" cellspacing="1" cellpadding="0">
                          <tr> 
                            <td width="30" class="title"><input type="checkbox" name="all_pr" value="Y" checked onclick='javascript:AllSelect(parent.smsList_in.form1.pr)'></td>
                            <td width="30" class="title">연번</td>
                            <td width="78" class="title">지점</td>
                            <td width="123" class="title">부서</td>
                            <td width="83" class="title">직급</td>
                            <td width="113" class="title">성명</td>
                            <td width="115" class="title">휴대폰번호</td>
                          </tr>
                        </table>
                    </td>
                </tr>
            </table>
	    </td>
    </tr>
</table>
</body>
</html>
